local ReplicatedStorage = game:GetService("ReplicatedStorage")

local t = require(ReplicatedStorage.types)

--[[
	In our game we don't want to store everything in our player component. Rather keep a
	hashmap on the side so we can do lookups much faster rather than doing a dynamic query
]]
export type PlayerDetails = {
	my_orders: { t.Entity | t.Id },
	my_accepted_orders: { t.Entity | t.Id },
	my_pickedup_orders: { t.Entity | t.Id },
	my_orders_to_drop_off: { t.Entity },
	my_active_delivery_conditions: { t.Entity },
	-- Would we actually turn this into a table containing multiple other fields?

	-- This should actually behave like a set
	my_backpack_collectables: { t.Entity },
	my_backpack_furnishings: { t.Entity },
}

local store: {
	[Player]: PlayerDetails,
} = {}

return store
