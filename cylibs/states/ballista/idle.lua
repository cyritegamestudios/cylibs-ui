require('tables')
require('lists')
require('logger')

local PlayerUtil = require('cylibs/util/player_util')

local ActionQueue = require('cylibs/actions/action_queue')
local CommandAction = require('cylibs/actions/command')

local State = require('cylibs/states/state')
local IdleState = setmetatable({}, {__index = State })
IdleState.__index = IdleState

function IdleState.new(action_queue)
	local self = setmetatable(State.new('Idle', L{'Idle', 'Engaged'}), IdleState)
	self.action_queue = action_queue
	self.current_target_id = nil
	self.nearby_enemies = L{}
	return self
end

function IdleState:enter_state()
	State.enter_state(self)

	notice("Entering Idle state")

	self:get_user_events().action = windower.register_event('postrender', function()
		-- Re-calculate nearby enemies
		self:update_nearby_enemies_display(self:get_nearby_enemies())
	end)
end

function IdleState:leave_state()
	State.leave_state(self)

	notice("Finished IdleState")
	
	self.current_target_id = nil

	self.action_queue:clear()
end

-- Returns a list of nearby enemies
function IdleState:get_nearby_enemies()
	local result = L{}

	local mob_array = windower.ffxi.get_mob_array()
    for i, mob in pairs(mob_array) do
		if mob and math.sqrt(mob.distance) < 30 and not mob.in_party and not mob.in_alliance then
			result:append(mob)
		end
    end
end

function IdleState:update_nearby_enemies_display()
	for mob in self.nearby_enemies:it() do
		-- TODO: update enemy in display
	end 
end

return IdleState



