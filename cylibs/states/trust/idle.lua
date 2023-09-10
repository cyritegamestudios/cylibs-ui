require('tables')
require('lists')
require('logger')

local PlayerUtil = require('cylibs/util/player_util')

local ActionQueue = require('cylibs/actions/action_queue')
local CommandAction = require('cylibs/actions/command')
local AttackAction = require('cylibs/actions/attack')
local WaitAction = require('cylibs/actions/wait')

local State = require('cylibs/states/state')
local TrustIdleState = setmetatable({}, {__index = State })
TrustIdleState.__index = TrustIdleState

function TrustIdleState.new(action_queue, assist_mode)
	local self = setmetatable(State.new('Idle', L{'Idle', 'Engaged'}), TrustIdleState)
	self.action_queue = action_queue
	self.assist_mode = assist_mode
	self.current_target_id = nil
	self.user_events = {}
	return self
end

function TrustIdleState:clean_up()
	if self.user_events then
        for _,event in pairs(self.user_events) do
            windower.unregister_event(event)
        end
    end
	
	self.user_events = {}
end

function TrustIdleState:enter_state()
	State.enter_state(self)

	self.user_events.time_change = windower.register_event('time change', function(new_time, old_time) 
		if self.assist_mode.value == 'Party' then
			local target = windower.ffxi.get_mob_by_target("bt")
			if target ~= nil and target.hpp > 0 and windower.ffxi.get_player().target_index ~= target.index then
				self:engage_target(target.id)
			end
		end
	end)
end

function TrustIdleState:leave_state()
	self:clean_up()
end

function TrustIdleState:engage_target(target_id)
	print("Engaging %i":format(target_id))

	local engage_action = AttackAction.new(target_id)
	self.action_queue:push_action(engage_action)
end

return TrustIdleState



