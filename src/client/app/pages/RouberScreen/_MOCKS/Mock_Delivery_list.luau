local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cheese_pizza = require(ReplicatedStorage.common.configs.food.cheese_pizza)
local tim_hortons = require(ReplicatedStorage.common.configs.restaurant.tim_hortons)
local tim_hortons_signature_coffee =
	require(ReplicatedStorage.common.configs.food.tim_hortons_signature_coffee)
local types = require(ReplicatedStorage.types)

local mock_delivery_list: { [string]: types.DeliveryOrderType } = {
	["one"] = {
		delivery_type = "not sure what this is yet",
		foods_list = {
			{
				name = tim_hortons_signature_coffee.display_name,
				image = tim_hortons_signature_coffee.display_image,
				rarity = tim_hortons_signature_coffee.rarity_value,
			},
		},
		has_mystery_box = false,
		house_address = "33 Bobux Drive",
		house_name = "we don't display this eyt",
		order_id = -1 :: never,
		order_rating = 5,
		restaurant_address = "1 Roblox Drive",
		restaurant_image = tim_hortons.display_image,
		restaurant_name = tim_hortons.display_name,
		reward_amount = 20400,
	},
	["two"] = {
		delivery_type = "not sure what this is yet",
		foods_list = {
			{
				name = cheese_pizza.display_name,
				image = cheese_pizza.display_image,
				rarity = cheese_pizza.rarity_value,
			},
		},
		has_mystery_box = false,
		house_address = "121 Xubob St. ",
		house_name = "we don't display this eyt",
		order_id = -2 :: never,
		order_rating = 6,
		restaurant_address = "22 Roblox Drive",
		restaurant_image = tim_hortons.display_image,
		restaurant_name = tim_hortons.display_name,
		reward_amount = 72400,
	},
}

return mock_delivery_list
