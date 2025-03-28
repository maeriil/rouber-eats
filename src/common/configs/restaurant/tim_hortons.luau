local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cream_cheese_bagel = require(ReplicatedStorage.common.configs.food.cream_cheese_bagel)
local iced_capp = require(ReplicatedStorage.common.configs.food.iced_capp)
local tim_hortons_signature_coffee =
	require(ReplicatedStorage.common.configs.food.tim_hortons_signature_coffee)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local restaurant: types.RestaurantConfigType = {
	id = world:entity() :: types.Entity,
	string_id = script.Name,
	display_name = "Tim Horton's",
	display_image = "Timmies Logo here.",

	foods = {
		tim_hortons_signature_coffee.id,
		iced_capp.id,
		cream_cheese_bagel.id,
	},

	base_value = 50,
	rarity_value = 0.6,

	category = "Cafe",
	nationality = "Any",
}

return restaurant
