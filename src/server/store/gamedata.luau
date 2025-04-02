local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

local function f(x: number): () -> ()
	return function() end
end

return {
	food_map = {} :: { [types.Entity]: types.FoodConfigType },
	restaurant_map = {} :: { [types.Entity]: types.RestaurantConfigType },
}
