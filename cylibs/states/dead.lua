require('tables')
require('logger')
require('vectors')

local Action = {}
Action.__index = Action

-- Constructor for vectors. Optionally provide dimension n, to avoid computing the dimension from the table.
function Action.new(x, y, z)
  local self = setmetatable({
      x = x;
      y = y;
      z = z;
	  cancelled = false;
    }, Action)
  return self
end

function Action:can_perform()
	if self:is_cancelled() then
		return false
	end
	return true
end

function Action:perform(completion)
	self.completion = completion
end

function Action:complete(success)
	self.completed = true

	if self.completion ~= nil then
		self.completion(success)
		self.completion = nil
	end
end

function Action:cancel()
	notice("Cancelling %s":format(self:tostring()))

	self.cancelled = true

	if self.completion ~= nil then
		self.completion(false)
		self.completion = nil
	end
end

function Action:get_position()
	local v = vector.zero(3)

	v[1] = self.x
	v[2] = self.y
	v[3] = self.z

	return v
end

function Action:gettype()
	return "action"
end

function Action:getrawdata()
	local res = {}
	
	res.action = {}
	res.action.x = self.x
	res.action.y = self.y
	res.action.z = self.z
	
	return res
end

function Action:is_cancelled()
	return self.cancelled
end

function Action:is_completed()
	return self.completion == nil
end

function Action:copy()
	return Action.new(self:get_position()[1], self:get_position()[2], self:get_position()[3])
end

function Action:tostring()
  return "Action %d, %d":format(self:get_position()[1], self:get_position()[2])
end

return Action



