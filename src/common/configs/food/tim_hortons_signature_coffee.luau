local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local food: types.FoodConfigType = {
	id = world:entity() :: types.Entity,
	string_id = script.Name,
	display_name = "Tim Horton's Dark Roast Double Double",
	display_image = "http://www.roblox.com/asset/?id=13457330819",
	category = "Coffees and Teas",
	nationality = "Any",

	-- Value related stuff
	base_value = 30,
	rarity_value = 0.65,

	-- Conditions
	can_be_hot = true,

	items = {},
}

return food
