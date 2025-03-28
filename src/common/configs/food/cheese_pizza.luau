local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local food: types.FoodConfigType = {
	id = world:entity() :: types.Entity,
	string_id = script.Name,
	display_name = "Cheese Pizza",
	display_image = "path to the image here",
	category = "Pizza",
	nationality = "Any",

	-- Value related stuff
	base_value = 30,
	rarity_value = 0.65,

	-- Conditions
	can_be_hot = false,
}

return food
