local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.types)

--[[
	In our game we don't want to store everything in our player component. Rather keep a
	hashmap on the side so we can do lookups much faster rather than doing a dynamic query
]]
export type PlayerDetails = {
	my_orders: { t.Entity },
}

local store: {
	[Player]: PlayerDetails,
} = {}

return store
