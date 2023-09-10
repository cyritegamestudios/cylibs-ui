require('tables')
require('lists')
require('logger')

local PlayerUtil = require('cylibs/util/player_util')

local WeaponSkillAction = require('cylibs/actions/weapon_skill')

local State = require('cylibs/states/state')
local EngagedState = setmetatable({}, {__index = State })
EngagedState.__index = EngagedState

function EngagedState.new(action_queue)
	local self = setmetatable(State.new('Engaged', L{'Idle'}), EngagedState)
	self.action_queue = action_queue
	self.current_weapon_skill = nil
	self.current_target = nil
	self.weapon_skill_spam_enabled = false
	return self
end

function EngagedState:enter_state()
	notice("Entering Engaged state")

	self:get_user_events().action = windower.register_event('postrender', function()
		self.current_target = self:get_current_target()
	end)

end

function EngagedState:leave_state()
	State.leave_state(self)

	notice("Finished EngageState")

	self.current_weapon_skill = nil
	
	self.action_queue:clear()
end

function EngagedState:use_weapon_skill()

end

function EngagedState:get_current_target()
	local target_index = windower.ffxi.get_player().target_index
	if target_index ~= nil then
		return windower.ffxi.get_mob_by_id(target_index)
	end
	return nil
end

return EngagedState



