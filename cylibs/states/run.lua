require('tables')
require('lists')
require('logger')

local PlayerUtil = require('cylibs/util/player_util')
local Path = require('cylibs/paths/path')

local WeaponSkillAction = require('cylibs/actions/weapon_skill')

local State = require('cylibs/states/state')
local RunState = setmetatable({}, {__index = State })
RunState.__index = RunState

function RunState.new(action_queue, path_file_name)
	local self = setmetatable(State.new('Running', L{'Idle', 'Engaged'}), RunState)
	self.action_queue = action_queue
	self.path = Path.new(path_file_name)
	self.user_events = {}
	return self
end

function RunState:enter_state()
	notice("Entering Run state")
	
	self.user_events.action = windower.register_event('postrender', function()
	
	end)
end

function RunState:leave_state()
	notice("Finished EngageState")

	if self.user_events then
        for _,event in pairs(self.user_events) do
            windower.unregister_event(event)
        end
    end
	
	self.user_events = {}
	
	self.action_queue:clear()
	
	PlayerUtil.stop_moving()
end

return RunState



