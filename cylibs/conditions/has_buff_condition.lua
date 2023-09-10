---------------------------
-- Condition checking whether the player has a buff.
-- @class module
-- @name HasBuffCondition

local buff_util = require('cylibs/util/buff_util')

local Condition = require('cylibs/conditions/condition')
local HasBuffCondition = setmetatable({}, { __index = Condition })
HasBuffCondition.__index = HasBuffCondition

function HasBuffCondition.new(buff_name)
    local self = setmetatable(Condition.new(), HasBuffCondition)
    self.buff_id = buff_util.buff_id(buff_name)
    return self
end

function HasBuffCondition:is_satisfied(target_index)
    local target = windower.ffxi.get_mob_by_index(target_index)
    if target and target.index == windower.ffxi.get_player().index then
        return buff_util.is_buff_active(self.buff_id)
    end
    return false
end

function HasBuffCondition:is_player_only()
    return true
end

function HasBuffCondition:tostring()
    return "HasBuffCondition"
end

return HasBuffCondition




