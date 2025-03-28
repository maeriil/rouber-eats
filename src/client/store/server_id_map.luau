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
	restaurant_map = {} :: EntityTable,
	order_map = {} :: EntityTable,
	residence_map = {} :: EntityTable,
	residence_owner_map = {} :: EntityTable,
	food_map = {} :: EntityTable,
}
