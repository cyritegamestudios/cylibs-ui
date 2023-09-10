local CollectionViewDelegate = require('cylibs/ui/collection_view/collection_view_delegate')
local View = require('cylibs/ui/views/view')

local CollectionView = setmetatable({}, {__index = View })
CollectionView.__index = CollectionView

---
-- Creates a new CollectionView instance with the specified data source and layout.
--
-- @tparam CollectionViewDataSource dataSource The data source providing content for the collection view.
-- @tparam CollectionViewLayout layout The layout strategy for arranging items in the collection view.
-- @tparam CollectionViewDelegate delegate (optional) The delegate for interacting with items in the collection view.
-- @treturn CollectionView The newly created CollectionView instance.
--
function CollectionView.new(dataSource, layout, delegate)
    local self = setmetatable(View.new(), CollectionView)

    self.layout = layout
    self.dataSource = dataSource
    self.delegate = delegate or CollectionViewDelegate.new(self)
    self.allowsMultipleSelection = false

    self:getDisposeBag():addAny(L{ self.delegate, self.dataSource, self.layout })

    self.dataSource:onItemsChanged():addAction(function(addedIndexPaths, removedIndexPaths, updatedIndexPaths)
        self.layout:setNeedsLayout(self, addedIndexPaths, removedIndexPaths, updatedIndexPaths)
    end)

    return self
end

---
-- Returns the data source associated with the collection view.
--
-- @treturn CollectionViewDataSource The data source.
--
function CollectionView:getDataSource()
    return self.dataSource
end

---
-- Returns the delegate associated with the collection view.
--
-- @treturn CollectionViewDelegate The delegate.
--
function CollectionView:getDelegate()
    return self.delegate
end

function CollectionView:layoutIfNeeded()
    View.layoutIfNeeded(self)

    self.layout:layoutSubviews(self)
end

return CollectionView