local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buildings_map = require(ReplicatedStorage.common.configs.buildings.buildings_map)
local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)
local setup_door = require(ReplicatedStorage.common.configs.buildings.setup_door)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function setup_house_owner(server_owner_id: types.Entity, owner: Model, is_npc: boolean)
	local owner_id = world:entity() :: types.Entity
	world:add(owner_id, c.HouseOwner)
	world:set(owner_id, c.EntityId, server_owner_id)
	world:set(owner_id, c.Name, owner.Name)
	world:set(owner_id, c.Model, owner)

	if is_npc then
		-- We found an npc
		world:add(owner_id, c.NPC)
		world:add(owner_id, c.HouseNPC)
	end

	server_id_map.residence_owner_map[server_owner_id] = owner_id
end

local request_bulk_create_house_owner = clientevents.Building.bulk_create_house_owners
local request_create_house_owner = clientevents.Building.create_house_owner
local function setup_house_owner_event_handler()
	for _, server_id_list, owner_name_list, is_npc_list in request_bulk_create_house_owner.iter() do
		-- for _, server_id_list, owner_name_list, is_npc_list in
		-- 	events.BulkCreateHouseOwners:query():client():iter()
		-- do
		local n = #server_id_list

		warn(`Bulk setting up house {n} owners `)

		for i = 1, n do
			local server_owner_id = server_id_list[i] :: never
			local owner_name = owner_name_list[i] :: never
			local is_npc = is_npc_list[i]

			setup_house_owner(server_owner_id, owner_name, is_npc)
		end
	end

	for _, server_owner_id, owner_model, is_npc in request_create_house_owner.iter() do
		-- for _, server_owner_id, owner_model, is_npc in events.CreateHouseOwner:query():client():iter() do
		setup_house_owner(server_owner_id :: never, owner_model, is_npc)
	end
end

local function get_appropriate_exterior_house(exterior_house: string)
	local house_model_readonly = buildings_map[exterior_house]
	assert(
		house_model_readonly,
		`Building model with name {exterior_house} does not exist. This is a bug`
	)

	local house_model = house_model_readonly.Exterior:Clone()
	return house_model
end

local house_parent = workspace:FindFirstChild("House") :: Folder

local function setup_house_on_client(
	server_id: types.Entity,
	doormat_cf: CFrame,
	interior_model: Model,
	exterior_house: string,
	owner_id: types.Entity
)
	-- local client_owner_id = get_clientownerid_fromserver(owner_id)
	local client_owner_id = server_id_map.residence_owner_map[owner_id]
	assert(client_owner_id ~= nil, `It cannot be nILL!!!`)
	local exterior_model = get_appropriate_exterior_house(exterior_house)

	exterior_model:PivotTo(
		CFrame.lookAlong(doormat_cf.Position, doormat_cf.LookVector)
			-- We are adding 180 degree rotation cuz our house's root part is rotated 180 degrees
			* CFrame.Angles(0, math.rad(180), 0)
	)
	exterior_model.Parent = house_parent

	local house_id = world:entity() :: types.Entity
	local interior_id, interior_cleanup = ref(interior_model)
	local exterior_id, exterior_cleanup = ref(exterior_model)
	local player_name = world:get(client_owner_id, c.Name)
	warn(`[CLIENT]: Setting up a house for {player_name}`)

	assert(
		player_name,
		`Client owner must contain a name component. We use this to naem the players house`
	)

	local interior_root = interior_model.PrimaryPart
	assert(interior_root, `House {player_name}'s interior model does not have a primary part`)
	local exterior_root = exterior_model.PrimaryPart
	assert(exterior_root, `House {player_name}'s exterior model does not have a primary part`)

	interior_root.Transparency = 1
	exterior_root.Transparency = 1

	world:set(house_id, c.House, exterior_house)
	world:set(house_id, pairs.BuildingInteriorId, interior_id)
	world:set(house_id, pairs.BuildingExteriorId, exterior_id)
	world:set(house_id, c.Name, player_name)
	world:set(house_id, c.EntityId, server_id)
	world:set(house_id, c.OccupiedByPlayer, client_owner_id)

	world:set(interior_id, c.Parent, house_id)
	world:set(interior_id, c.Model, interior_model)
	world:set(interior_id, c.PrimaryPart, interior_root)
	world:set(interior_id, c.Transform, interior_root.CFrame)
	world:set(interior_id, c.Cleanup, interior_cleanup)
	world:set(interior_id, c.Name, player_name)
	world:set(interior_id, c.EntityId, server_id)
	world:add(interior_id, c.Interior)

	world:set(exterior_id, c.Parent, house_id)
	world:set(exterior_id, c.Model, exterior_model)
	world:set(exterior_id, c.PrimaryPart, exterior_root)
	world:set(exterior_id, c.Transform, exterior_root.CFrame)
	world:set(exterior_id, c.Cleanup, exterior_cleanup)
	world:set(exterior_id, c.Name, player_name)
	world:set(exterior_id, c.EntityId, server_id)
	world:add(exterior_id, c.Exterior)

	setup_door(interior_model, interior_id)
	setup_door(exterior_model, exterior_id)

	server_id_map.residence_map[server_id] = house_id
	return house_id
end

local request_bulk_create_houses = clientevents.Building.bulk_create_house
local response_bulk_create_houses = clientevents.PlayerEvents.i_have_setup_houses
local request_create_house = clientevents.Building.create_house
local function setup_house_event_handler()
	for _, server_id_list, doormat_cf_list, interior_model_list, exterior_house_list, owner_id_list in
		request_bulk_create_houses.iter()
	do
		local n = #server_id_list
		warn(`Bulk setting up {n} houses`)
		for i = 1, n do
			task.spawn(function()
				local server_id = server_id_list[i] :: never
				local doormat_cf = doormat_cf_list[i]
				local interior_model = interior_model_list[i]
				local exterior_type = exterior_house_list[i]
				local server_owner_id = owner_id_list[i]

				setup_house_on_client(server_id, doormat_cf, interior_model, exterior_type, server_owner_id)
			end)
		end

		response_bulk_create_houses.fire()
	end

	for _, server_id, doormat_cf, interior_model, exterior_type, server_owner_id in
		request_create_house.iter()
	do
		warn(`SETTING UP HOUSE ON NON BULK CREATE, server id = {server_id}`)
		setup_house_on_client(
			server_id :: never,
			doormat_cf,
			interior_model,
			exterior_type,
			server_owner_id
		)
	end
end

local function system()
	setup_house_owner_event_handler()
	setup_house_event_handler()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Client.GeneralSetups.Setup,
	runConditions = {},
}
