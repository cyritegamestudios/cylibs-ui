_libs = _libs or {}

require('tables')
require('lists')
require('logger')
require('vectors')

local packets = require('packets')
local res = require('resources')

local SynthResult = {}
SynthResult.__index = SynthResult

_libs.SynthResult = SynthResult

local success_results = L{ 0, 12, 13 }
local failure_results = L{ 1, 2, 4, 5 }

function SynthResult.new(data)
	local self = setmetatable({}, SynthResult)
	self.packet = packets.parse('incoming', data);
	return self
end

function SynthResult:is_success()
	local result = self.packet['Result']
	if result then 
		return success_results:contains(result)
	end
	return false
end

function SynthResult:is_failure()
	local result = self.packet['Result']
	if result then 
		return failure_results:contains(result)
	end
	return false
end

function SynthResult:get_packet()
	return self.packet
end

function SynthResult:get_result()
	local fields = packets.fields('incoming', 0x06F, self.packet._raw)
	for field in fields:it() do
		if field.label == 'Result' then
			local result = field.fn(self.packet['Result'], self.packet._raw)
			return result
		end
	end
    return 'Unknown'
end

function SynthResult:get_quality()
	return self.packet['Quality']
end

function SynthResult:get_quantity()
	if self:is_failure() then
		return 0
	end
	return self.packet['Count']	
end

function SynthResult:get_item()
	local item_id = self.packet['Item']
	return res.items[item_id]
end

function SynthResult:lost_items()
	if self:is_success() then
		return L{}
	end
	local lost_items = L{}
	for i=1, 8, 1 do
		local item_id = tonumber(self.packet["Lost Item %d":format(i)])
		if item_id ~= 0 then
			lost_items:append(res.items[item_id])
		end
	end
	return lost_items
end

function SynthResult:get_skills()
	local skills = L{}

	for i=1, 4, 1 do
		local skill_id = tonumber(self.packet["Skill %d":format(i)])
		if skill_id ~= 0 then
			skills:append(skill_id)
		end
	end
	return skills
end

function SynthResult:get_crystal()
	local item_id = self.packet['Crystal']
	return res.items[item_id]
end

function SynthResult:get_packet()
	return self.packet
end

function SynthResult:tostring()
	local result = ""
	
	if self:is_success() then
		result = "Success"
	else
		if self:lost_items():length() > 0 then
			result = "Failure, Lost Items"
		else
			result = "Failure"
		end
	end
	return "SynthResult: %s":format(result)
end

return SynthResult



