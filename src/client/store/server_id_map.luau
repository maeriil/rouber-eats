local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

--[[
	For all the important things this file contains the tables which we can populate to keep
	track of the [Server Entity Id] => Client Entity Id. The Client entity will also contain
	a component called EntityId which we can retrieve if we need to know the server Id too.

	This way allows us to quickly retrieve the client counter part as the server will always
	instead send the Server Entity Id
]]

type EntityTable = { [types.Entity]: types.Entity }

return {
	-- This is unnecessary, we can simply send the restaurant name to the client
	restaurant_map = {} :: EntityTable,
	-- unsure
	residence_map = {} :: EntityTable,
	-- unsure
	residence_owner_map = {} :: EntityTable,
	-- this is unnecessary, we can simply send the food name to the client
	food_map = {} :: EntityTable,
	-- this is unnecessary, we can simply send the food name to the client
	store_map = {} :: EntityTable,
	-- this is unnecessary, we can simply send the food name to the client
	item_map = {} :: EntityTable,
	-- unsure
	order_map = {} :: EntityTable,
}
