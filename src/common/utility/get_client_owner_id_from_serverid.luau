local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local client_owner_id_query = world:query(c.EntityId):with(c.HouseOwner):cached()
local function find_appropriate_client_ownerid(server_id: types.Entity)
	local n = 0
	for client_id, server_id_mapped in client_owner_id_query:iter() do
		n += 1
		if server_id_mapped == server_id then return client_id end
	end

	error(
		`Could not find a client id that contains the server id {server_id} after {n} iterations. This should never happen`
	)
end

return find_appropriate_client_ownerid
