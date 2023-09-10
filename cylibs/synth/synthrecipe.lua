require('tables')
require('lists')
require('logger')
require('vectors')

local packets = require('packets')
local res = require('resources')
local recipes_lookup = require('cylibs/synth/recipes_lookup')
local synth_util = require('cylibs/synth/synth_util')
local md5 = require('cylibs/util/md5')
local urlcode = require('cylibs/util/urlcode')

local SynthRecipe = {}
SynthRecipe.__index = SynthRecipe


function SynthRecipe.new(data)
	local self = setmetatable({}, SynthRecipe)
	self.packet = packets.parse('outgoing', data);
	return self
end

function SynthRecipe:get_item()
	local ingredients = self:get_ingredients():map(function(item) 
		return item.en 
	end)
	ingredients:sort()
	
	local m = md5.new()
	m:update(synth_util.get_nq_crystal(self:get_crystal()))
	for ingredient in ingredients:it() do
		m:update(ingredient)
	end
	local hash = md5.tohex(m:finish())
	local recipe_name = recipes_lookup[hash]
	if recipe_name ~= nil then
		for i=1, 9, 1 do
			recipe_name = recipe_name:gsub("%%d":format(i), "")
		end
		recipe_name = string.trim(recipe_name)
		
		local item = synth_util.match_recipe_to_item(recipe_name)
		return item
	else
		return nil
	end
end

function SynthRecipe:get_ingredients()
	local ingredients = L{}
	for i=1, self:get_ingredient_count(), 1 do
		local item_id = tonumber(self.packet["Ingredient %d":format(i)])
		if item_id ~= 0 and res.items[item_id] ~= nil then
			ingredients:append(res.items[item_id])
		end
	end
	return ingredients
end

function SynthRecipe:get_ingredient_count()
	return self.packet["Ingredient count"]
end

function SynthRecipe:get_crystal()
	local item_id = self.packet['Crystal']
	return res.items[item_id]
end

function SynthRecipe:get_packet()
	return self.packet
end

function SynthRecipe:tostring()
	return "SynthRecipe: %s":format(self:get_ingredients())
end

return SynthRecipe



