require('tables')
require('lists')
require('logger')

local State = {}
State.__index = State

function State.new(name, transitions)
  local self = setmetatable({
	name = name;
	transitions = transitions;
	enter_time = nil;
	user_events = {};
  }, State)
  return self
end

function State:can_transition_to_state(state)
	if self.transitions:contains(state:get_name()) then
		return true
	end
	return false
end

function State:enter_state()
	self.enter_time = os.time()
end

function State:leave_state()
	if self.user_events then
        for _,event in pairs(self.user_events) do
            windower.unregister_event(event)
        end
    end
	
	self.user_events = {}
end

function State:get_name()
	return self.name
end

function State:get_user_events()
	return self.user_events
end

function State:get_time_in_state()
	return os.time() - self.enter_time
end

return State



