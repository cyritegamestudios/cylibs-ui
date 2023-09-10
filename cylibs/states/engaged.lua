require('tables')
require('lists')
require('logger')

local BuffUtil = require('cylibs/util/buff_util')
local PlayerUtil = require('cylibs/util/player_util')

local WeaponSkillAction = require('cylibs/actions/weapon_skill')

local State = require('cylibs/states/state')
local EngagedState = setmetatable({}, {__index = State })
EngagedState.__index = EngagedState

function EngagedState.new(action_queue, weapon_skill_name, enable_aftermath)
	local self = setmetatable(State.new('Engaged', L{'Idle'}), EngagedState)
	self.action_queue = action_queue
	self.weapon_skill_name = weapon_skill_name
	self.current_weapon_skill = nil
	self.enable_aftermath = enable_aftermath
	self.user_events = {}
	return self
end

function EngagedState:enter_state()
	notice("Entering Engaged state")
	
	--[[self.user_events.action = windower.register_event('postrender', function()
		if self.current_weapon_skill == nil then
			local min_tp = 1000
			if self.enable_aftermath and not BuffUtil.is_buff_active(272) then
				min_tp = 3000
			end
		
			local target_index = windower.ffxi.get_player().target_index
			if target_index == nil then
				return
			end
			
			local target = windower.ffxi.get_mob_by_index(target_index)
			if windower.ffxi.get_player().vitals.tp >= min_tp and self.weapon_skill_name ~= nil then
				local weapon_skill_action = WeaponSkillAction.new(self.weapon_skill_name)
				self.action_queue:push_action(weapon_skill_action)
				
				self.current_weapon_skill = weapon_skill_action
			end
		else
			if self.current_weapon_skill:is_completed() then
				self.current_weapon_skill = nil
			end
		end
	end)]]
end

function EngagedState:leave_state()
	notice("Finished EngageState")

	if self.user_events then
        for _,event in pairs(self.user_events) do
            windower.unregister_event(event)
        end
    end
	
	self.user_events = {}
	self.current_weapon_skill = nil
	
	self.action_queue:clear()
	
	PlayerUtil.stop_moving()
end

function EngagedState:get_current_target()
	local target = windower.ffxi.get_mob_by_target("bt")
	return target
end

return EngagedState



