local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

return {
	food_map = {} :: { [types.Entity]: types.FoodConfigType },
	restaurant_map = {} :: { [types.Entity]: types.RestaurantConfigType },
	store_map = {} :: { [types.Entity]: types.StoreConfigType },
	item_map = {} :: { [types.Entity]: types.ItemConfigType },
}
