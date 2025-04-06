local ReplicatedStorage = game:GetService("ReplicatedStorage")
local test_part_1 = require(ReplicatedStorage.common.configs.items.test_part_1)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local food: types.FoodConfigType = {
	id = world:entity() :: types.Entity,
	string_id = script.Name,
	display_name = "Iced Capp",
	display_image = "http://www.roblox.com/asset/?id=13969468048",
	category = "Coffees and Teas",
	nationality = "Any",

	-- Value related stuff
	base_value = 30,
	rarity_value = 0.65,

	-- Conditions
	can_be_hot = false,

	items = {
		test_part_1.id,
	},
}

return food
