require('tables')
require('lists')
require('logger')

local BuffUtil = require('cylibs/util/buff_util')
local PlayerUtil = require('cylibs/util/player_util')

local FollowAction = require('cylibs/actions/follow')
local WeaponSkillAction = require('cylibs/actions/weapon_skill')
local SkillchainMaker = require('cylibs/battle/skillchain_maker')

local State = require('cylibs/states/state')
local EngagedState = setmetatable({}, {__index = State })
EngagedState.__index = EngagedState

function EngagedState.new(action_queue, auto_skillchain_mode)
	local self = setmetatable(State.new('Engaged', L{'Idle'}), EngagedState)
	self.action_queue = action_queue
	self.auto_skillchain_mode = auto_skillchain_mode
	self.user_events = {}
	self.skillchain_maker = SkillchainMaker.new()
	return self
end

function EngagedState:clean_up()
	self.skillchain_maker:disable()

	if self.user_events then
        for _,event in pairs(self.user_events) do
            windower.unregister_event(event)
        end
    end
	
	self.user_events = {}
end

function EngagedState:enter_state()
	local target = windower.ffxi.get_mob_by_target("bt")
	if target ~= nil and target.hpp > 0 then
		local follow_action = FollowAction.new(target.id)
		self.action_queue:push_action(follow_action)
	end
	if self.auto_skillchain_mode ~= 'None' then
		self.skillchain_maker:enable()
	end
end

function EngagedState:leave_state()
	self:clean_up()

	windower.ffxi.follow()
	windower.ffxi.run(false)
end

function EngagedState:get_current_target()
	local target = windower.ffxi.get_mob_by_target("bt")
	return target
end

return EngagedState



