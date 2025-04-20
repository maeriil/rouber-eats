local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

return {
	-- We don't need any of this, we instead communicate via string ids
	food_map = {} :: { [types.Entity]: types.FoodConfigType },
	restaurant_map = {} :: { [types.Entity]: types.RestaurantConfigType },
	store_map = {} :: { [types.Entity]: types.StoreConfigType },
	item_map = {} :: { [types.Entity]: types.ItemConfigType },
}
