require('tables')
require('logger')
require('vectors')
require('lists')

local StateMachine = {}
StateMachine.__index = StateMachine

-- Creates a new state machine with the given states and transitions.
--
-- Params
-- states: A list of State objects
-- initial_state: Initial state
function StateMachine.new(states, initial_state)
  local self = setmetatable({
	current_state = initial_state;
	states = states;
  }, StateMachine)
  self.current_state:enter_state()
  
  return self
end

-- Transitions the StateMachine to the given state
function StateMachine:enter_state(new_state)
	if new_state == nil then
		return false
	end

	if self.current_state:can_transition_to_state(new_state) then
		self.current_state:leave_state()
		self.current_state = new_state
		
		self.current_state:enter_state()
	end
	
	return true
end

function StateMachine:get_state_by_name(name)
	local matches = self.states:filter(function(state)
		return state:get_name() == name
	end)
	return matches[1]
end

return StateMachine



