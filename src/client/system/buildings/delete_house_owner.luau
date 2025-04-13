local ReplicatedStorage = game:GetService("ReplicatedStorage")

local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function cleanup_buildings(house_id: t.Entity)
	local interior_id, exterior_id =
		world:get(house_id, pairs.BuildingInteriorId, pairs.BuildingExteriorId)

	if not interior_id or not exterior_id then
		error(`Could not find a valid interior and exterior id for the buidlings. This is a bug!`)
	end

	local interior_cleanup = world:get(interior_id, c.Cleanup)
	local exterior_cleanup = world:get(exterior_id, c.Cleanup)
	assert(interior_cleanup and exterior_cleanup, `Both interior and exterior cleanup must exist`)

	interior_cleanup()
	exterior_cleanup()

	warn(`Deleting exterior_id={exterior_id}, interior_id={exterior_id}, and house_id={house_id}`)
	world:delete(interior_id)
	world:delete(exterior_id)
	world:delete(house_id)

	--//TODO: Server needs to send house_id too, as we need to delete it from the map
	-- server_id_map.residence_map[somethign ] = nil
end

local function cleanup_house_owner(server_owner_id: t.Entity)
	local client_owner_id = server_id_map.residence_owner_map[server_owner_id]
	if client_owner_id == nil then
		print("couldn't find the house owner id, ama just drop the req gang")
		return
	end
	if not world:contains(client_owner_id) then
		print(
			"technically this should never reach, but it might happen since we dont cleanupmap properly?"
		)
		server_id_map.residence_owner_map[server_owner_id] = nil
	end

	local house_id = world:get(client_owner_id, c.Residence)
	assert(house_id, `Could not find an appropriate house_id for the client owner. This is a bug`)

	cleanup_buildings(house_id :: t.Entity)

	-- local house_owner_cleanup = world:get(client_owner_id, c.Cleanup)
	-- assert(house_owner_cleanup, `Cleanup function must exist for the house owner`)

	-- house_owner_cleanup()
	world:delete(client_owner_id)
	server_id_map.residence_owner_map[server_owner_id] = nil
end

local request_delete_house_owner = clientevents.Building.delete_house_owner
local function system()
	for _, server_owner_id in request_delete_house_owner.iter() do
		warn(`Received request to clean up a house owner`)
		cleanup_house_owner(server_owner_id :: never)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Client.GeneralSetups.Cleanup,
	runConditions = {},
}
