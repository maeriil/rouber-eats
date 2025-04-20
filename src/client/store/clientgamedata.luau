local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

return {
	--[[
		TODO
		None of this should be needed anymore since the server should instead send the string key representation
		This removes the need for us to have a seperate config file to store the details
	]]
	food_map = {} :: { [types.Entity]: types.FoodConfigType },
	restaurant_map = {} :: { [types.Entity]: types.RestaurantConfigType },
	store_map = {} :: { [types.Entity]: types.StoreConfigType },
	item_map = {} :: { [types.Entity]: types.ItemConfigType },
}
