local Event = require('cylibs/events/Luvent')
local IndexPath = require('cylibs/ui/collection_view/index_path')

-- Define a simple collection data source table
local CollectionViewDataSource = {}
CollectionViewDataSource.__index = CollectionViewDataSource

function CollectionViewDataSource:onItemsChanged()
    return self.itemsChanged
end

-- Initialize a new collection
function CollectionViewDataSource.new(cellForItem)
    local self = setmetatable({}, CollectionViewDataSource)

    self.cellForItem = cellForItem
    self.sections = {}
    self.cellCache = {}
    self.itemsChanged = Event.newEvent()

    return self
end

function CollectionViewDataSource:destroy()
    self.itemsChanged:removeAllActions()

    for _, section in ipairs(self.cellCache) do
        for _, cachedCell in ipairs(section) do
            cachedCell:destroy()
        end
    end
end

-- Add an item to a specific section, creating the section if it doesn't exist
function CollectionViewDataSource:addItem(item, indexPath)
    local snapshot = self:createSnapshot()  -- Create a snapshot before making changes

    local section = indexPath.section
    local row = indexPath.row

    if not self.sections[section] then
        table.insert(self.sections, section, {items = {}})
    end
    table.insert(self.sections[section].items, row, item)

    -- Generate a diff
    local diff = self:generateDiff(snapshot)

    -- Trigger the itemsChanged event
    self.itemsChanged:trigger(diff.added, diff.removed, diff.updated)
end

-- Remove an item at a specific IndexPath
function CollectionViewDataSource:removeItem(indexPath)
    local snapshot = self:createSnapshot()  -- Create a snapshot before making changes

    table.remove(self.sections[indexPath.section].items, indexPath.row)

    -- Generate a diff
    local diff = self:generateDiff(snapshot)

    -- Trigger the itemsChanged event
    self.itemsChanged:trigger(diff.added, diff.removed, diff.updated)
end

function CollectionViewDataSource:removeAllItems()
    local snapshot = self:createSnapshot()  -- Create a snapshot before making changes

    -- Iterate through all sections and remove their items
    for _, section in ipairs(self.sections) do
        section.items = {}
    end

    -- Generate a diff
    local diff = self:generateDiff(snapshot)

    -- Trigger the itemsChanged event
    self.itemsChanged:trigger(diff.added, diff.removed, diff.updated)
end

-- Update an item at a specific IndexPath
function CollectionViewDataSource:updateItem(item, indexPath)
    local snapshot = self:createSnapshot()  -- Create a snapshot before making changes

    self.sections[indexPath.section].items[indexPath.row] = item

    -- Generate a diff
    local diff = self:generateDiff(snapshot)

    -- Trigger the itemsChanged event
    self.itemsChanged:trigger(diff.added, diff.removed, diff.updated)
end

-- Get the number of sections in the collection
function CollectionViewDataSource:numberOfSections()
    return #self.sections
end

-- Get the number of items in a specific section
function CollectionViewDataSource:numberOfItemsInSection(section)
    if not self.sections[section] then
        return 0
    end
    return #self.sections[section].items
end

-- Get an item at a specific IndexPath
function CollectionViewDataSource:itemAtIndexPath(indexPath)
    return self.sections[indexPath.section].items[indexPath.row]
end

-- Get the cell for a specific IndexPath
function CollectionViewDataSource:cellForItemAtIndexPath(indexPath)
    local item = self:itemAtIndexPath(indexPath)

    -- Check if a cell for this index path already exists in the cache
    local cachedCell = self.cellCache[indexPath.section] and self.cellCache[indexPath.section][indexPath.row]

    if cachedCell then
        return cachedCell
    else
        local newCell = self.cellForItem(item, indexPath)

        -- Create a cache for the section if it doesn't exist
        self.cellCache[indexPath.section] = self.cellCache[indexPath.section] or {}
        self.cellCache[indexPath.section][indexPath.row] = newCell

        return newCell
    end
end

-- Helper function to create a snapshot of the dataSource
function CollectionViewDataSource:createSnapshot()
    local snapshot = {}
    for sectionIndex, section in ipairs(self.sections) do
        snapshot[sectionIndex] = { items = {} }
        for rowIndex, item in ipairs(section.items) do
            snapshot[sectionIndex].items[rowIndex] = item
        end
    end
    return snapshot
end

-- Generate a diff based on changes to the dataSource
function CollectionViewDataSource:generateDiff(snapshot)
    local addedIndexPaths = {}
    local removedIndexPaths = {}
    local updatedIndexPaths = {}

    -- Compare sections and items
    for sectionIndex, section in ipairs(self.sections) do
        local snapshotSection = snapshot[sectionIndex]
        if not snapshotSection then
            -- Entire section is added
            for rowIndex, _ in ipairs(section.items) do
                table.insert(addedIndexPaths, IndexPath.new(sectionIndex, rowIndex))
            end
        else
            -- Compare items within section
            for rowIndex, _ in ipairs(section.items) do
                local indexPath = IndexPath.new(sectionIndex, rowIndex)
                local snapshotItem = snapshotSection.items[rowIndex]
                local newItem = section.items[rowIndex]
                if snapshotItem ~= newItem then
                    table.insert(updatedIndexPaths, indexPath)
                end
            end
        end
    end

    -- Check for removed sections or items
    for sectionIndex, section in ipairs(snapshot) do
        local selfSection = self.sections[sectionIndex]
        if not selfSection then
            -- Entire section is removed
            for rowIndex, _ in ipairs(section.items) do
                table.insert(removedIndexPaths, IndexPath.new(sectionIndex, rowIndex))
            end
        else
            -- Compare items within section
            for rowIndex, _ in ipairs(section.items) do
                local indexPath = IndexPath.new(sectionIndex, rowIndex)
                local snapshotItem = section.items[rowIndex]
                local newItem = selfSection.items[rowIndex]
                if snapshotItem ~= newItem then
                    table.insert(updatedIndexPaths, indexPath)
                end
            end
        end
    end

    return {
        added = addedIndexPaths,
        removed = removedIndexPaths,
        updated = updatedIndexPaths
    }
end

return CollectionViewDataSource

