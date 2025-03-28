local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

return {
	food_map = {} :: { [types.Entity]: types.FoodConfigType },
	restaurant_map = {} :: { [types.Entity]: types.RestaurantConfigType },
}
