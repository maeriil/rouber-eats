local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

local mock_delivery_list: { types.DeliveryOrderType } = {
	{
		clientid = 10 :: any,
		deliverytype = "food-delivery",
		distance = 100,
		restaurant = {
			img = "",
			location = "2723 Chicken Farm",
			name = "Top Chicken",
		},
		reward = 100,
	},
	{
		clientid = 20 :: any,
		deliverytype = "pickup",
		distance = 20,
		restaurant = {
			img = "",
			location = "Airport",
			name = "Toronto Airport",
		},
		reward = 60,
	},
	{
		clientid = 30 :: any,
		deliverytype = "food-delivery",
		distance = 50,
		restaurant = {
			img = "",
			location = "Plaza",
			name = "Shawarma",
		},
		reward = 12,
	},
}

return mock_delivery_list
