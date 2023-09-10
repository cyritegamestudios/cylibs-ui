local CyTest = require('cylibs/tests/cy_test')
local CollectionViewDataSource = require('cylibs/ui/collection_view/collection_view_data_source')
local CollectionView = require('cylibs/ui/collection_view/collection_view')
local CollectionViewCell = require('cylibs/ui/collection_view/collection_view_cell')
local Event = require('cylibs/events/Luvent')
local IndexPath = require('cylibs/ui/collection_view/index_path')
local TextCollectionViewCell = require('cylibs/ui/collection_view/cells/text_collection_view_cell')
local TextItem = require('cylibs/ui/collection_view/items/text_item')
local TextStyle = require('cylibs/ui/style/text_style')
local VerticalFlowLayout = require('cylibs/ui/collection_view/layouts/vertical_flow_layout')
local Color = require('cylibs/ui/views/color')
local View = require('cylibs/ui/views/view')
local Frame = require('cylibs/ui/views/frame')

local CollectionViewTests = {}
CollectionViewTests.__index = CollectionViewTests

function CollectionViewTests:onCompleted()
    return self.completed
end

function CollectionViewTests.new()
    local self = setmetatable({}, CollectionViewTests)
    self.completed = Event.newEvent()
    return self
end

function CollectionViewTests:destroy()
    self.completed:removeAllActions()
end

function CollectionViewTests:run()
    --self:testCollectionView()
    self:debug()
    --self:testViews()

    self:onCompleted():trigger(true)
end

-- Tests

function CollectionViewTests:testCollectionView()
    local dataSource = CollectionViewDataSource.new(function(item)
        local cell = CollectionViewCell.new(item)
        return cell
    end)

    local collectionView = CollectionView.new(dataSource, VerticalFlowLayout.new())

    collectionView:set_size(500, 500)
    collectionView:set_color(155, 0, 0, 0)
    collectionView:set_visible(true)
    collectionView:set_pos(500, 200)

    local item1 = TextItem.new('Item 1')
    dataSource:addItem(item1, IndexPath.new(1, 1))

    CyTest.assertEqual(function() return dataSource:numberOfSections()  end, 1, "numberOfSections()")
    CyTest.assertEqual(function() return dataSource:numberOfItemsInSection(1)  end, 1, "numberOfItemsInSection(1)")
    CyTest.assertEqual(function() return dataSource:itemAtIndexPath(IndexPath.new(1, 1))  end, item1, "itemAtIndexPath(1, 1)")

    local item2 = TextItem.new('Item 2')
    dataSource:addItem(item2, IndexPath.new(1, 2))

    CyTest.assertEqual(function() return dataSource:numberOfItemsInSection(1)  end, 2, "numberOfItemsInSection(1)")
    CyTest.assertEqual(function() return dataSource:itemAtIndexPath(IndexPath.new(1, 2))  end, item2, "itemAtIndexPath(1, 2)")

    dataSource:removeItem(IndexPath.new(1, 1))

    CyTest.assertEqual(function() return dataSource:itemAtIndexPath(IndexPath.new(1, 1))  end, item2, "itemAtIndexPath(1, 1)")
end

function CollectionViewTests:debug()
    local dataSource = CollectionViewDataSource.new(function(item)
        local cell = TextCollectionViewCell.new(item)
        return cell
    end)

    local collectionView = CollectionView.new(dataSource, VerticalFlowLayout.new(10))

    collectionView:setPosition(500, 200)
    collectionView:setSize(500, 500)
    collectionView:setBackgroundColor(Color.new(175, 0, 0, 0))

    collectionView:layoutIfNeeded()

    local item1 = TextItem.new('Item 1', TextStyle.Default.Text)
    dataSource:addItem(item1, IndexPath.new(1, 1))

    local item2 = TextItem.new('Item 2', TextStyle.Default.Text)
    dataSource:addItem(item2, IndexPath.new(1, 2))
end

function CollectionViewTests:testViews()
    local view1 = View.new(Frame.new(500, 200, 500, 500))
    view1:setBackgroundColor(Color.new(150, 0, 0 , 0))

    local view2 = View.new(Frame.new(500, 200, 100, 100))
    view2:setBackgroundColor(Color.new(150, 255, 0 , 0))

    view1:addSubview(view2)
    view1:setPosition(500, 200)
    view1:layoutIfNeeded()

    view2:setPosition(50, 50)
    view2:layoutIfNeeded()
end

return CollectionViewTests