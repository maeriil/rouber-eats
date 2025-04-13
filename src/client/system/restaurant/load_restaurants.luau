local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local clientgamedata = require(ReplicatedStorage.client.store.clientgamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local p = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local restaurant_map = require(ReplicatedStorage.common.configs.restaurant)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)
local setup_door = require(ReplicatedStorage.common.configs.buildings.setup_door)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local attributes = require(ReplicatedStorage.types.attributes)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local instance_added = {}
local instance_removed = {}

CollectionService:GetInstanceAddedSignal(tags.Restaurant):Connect(function(instance: Instance)
	local client_id_attribute = instance:GetAttribute(attributes.clientid)

	if client_id_attribute == nil then
		-- warn(`Setting up restaurant {instance.Name}`)
		table.insert(instance_added, instance)
	end
end)

local function setup_restuarant_to_client(
	restaurant_folder: Folder,
	interior: Model,
	exterior: Model
)
	local restaurant_name = restaurant_folder.Name
	local interior_primary = interior.PrimaryPart :: Part
	local exterior_priamry = exterior.PrimaryPart :: Part
	local restaurant_config = restaurant_map[restaurant_name]
	assert(
		restaurant_config,
		`Restaurant with name {restaurant_name} does not exist in config folder...`
	)

	local display_name = restaurant_config.display_name
	local parent_id = restaurant_config.id
	local interior_id = ref(interior)
	local exterior_id = ref(exterior)
	local interior_server_mapped_id = interior:GetAttribute(attributes.serverid) :: t.Entity
	local exterior_server_mapped_id = exterior:GetAttribute(attributes.serverid) :: t.Entity

	assert(
		interior_server_mapped_id == exterior_server_mapped_id,
		`Serverid Map at this point should match`
	)

	world:add(parent_id, c.Restaurant)
	world:set(parent_id, c.Name, display_name)
	world:set(parent_id, p.BuildingInteriorId, interior_id)
	world:set(parent_id, p.BuildingExteriorId, exterior_id)
	world:set(parent_id, c.EntityId, interior_server_mapped_id)

	-- tbh i dont think we need to set primary part? I dont wanna put too many components
	-- too many components = increase time complexity to finding component for jecs

	world:add(interior_id, c.Restaurant)
	world:add(interior_id, c.Interior)
	world:set(interior_id, c.Parent, parent_id)
	world:set(interior_id, c.Name, display_name)
	world:set(interior_id, c.Transform, interior_primary.CFrame)
	world:set(interior_id, c.EntityId, interior_server_mapped_id)
	world:set(interior_id, c.Model, interior)

	world:add(exterior_id, c.Restaurant)
	world:add(exterior_id, c.Exterior)
	world:set(exterior_id, c.Parent, parent_id)
	world:set(exterior_id, c.Name, display_name)
	-- In the client sided, the transform server as a different purpose to server, here it will be
	-- used for pathfinding. It sorta acts as the restaurant's address
	world:set(exterior_id, c.Transform, exterior_priamry.CFrame)
	world:set(exterior_id, c.EntityId, exterior_server_mapped_id)
	world:set(exterior_id, c.Model, exterior)

	setup_door(interior, interior_id)
	setup_door(exterior, exterior_id)

	interior:SetAttribute(attributes.clientid, parent_id)
	exterior:SetAttribute(attributes.clientid, parent_id)
	restaurant_folder:SetAttribute(attributes.clientid, parent_id)

	server_id_map.restaurant_map[interior_server_mapped_id] = parent_id
	clientgamedata.restaurant_map[parent_id] = restaurant_config
	restaurant_map[restaurant_name] = nil
end

local completed = false
local function system()
	local n = #instance_added
	for i = n, 1, -1 do
		local folder = instance_added[i]
		assert(
			folder:IsA("Folder"),
			`Every restuarant must be of folder type as this allows us to group Interior/Exterior together`
		)
		local restaurant_name = folder.Name
		local interior = folder:FindFirstChild("Interior") or folder:FindFirstChild("interior")
		local exterior = folder:FindFirstChild("Exterior") or folder:FindFirstChild("exterior")

		assert(
			interior and interior:IsA("Model"),
			`Interior does not exist for the restuarant name {restaurant_name}. Verify it exists and is a model`
		)
		assert(
			exterior and exterior:IsA("Model"),
			`Exterior does not exist for the restuarant name {restaurant_name}. Verify it exists and is a model`
		)

		local interior_primary = interior.PrimaryPart
		local exterior_priamry = exterior.PrimaryPart

		assert(
			interior_primary,
			`Interior's Priamry part of the restaurant {restaurant_name} does not exist`
		)
		assert(
			exterior_priamry,
			`Exterior's Priamry Part of the restaurant {restaurant_name} does not exist`
		)

		local interior_server_mapped_id = interior:GetAttribute(attributes.serverid)
		local exterior_server_mapped_id = exterior:GetAttribute(attributes.serverid)
		assert(
			interior_server_mapped_id ~= nil,
			`Server attribute for Interior must exist at runtime for restuarant {restaurant_name}`
		)
		assert(
			exterior_server_mapped_id ~= nil,
			`Server attribute for Exterior must exist at runtime for restuarant {restaurant_name}`
		)
		assert(
			interior_server_mapped_id == exterior_server_mapped_id,
			`Unless we have changed our logic, it must be the case that both interior and exterior server attribute should be same`
		)

		warn(`Client-sided, Setting up the restaurant {restaurant_name}`)
		setup_restuarant_to_client(folder, interior, exterior)

		instance_added[i] = nil
	end

	if not completed and n > 0 then
		-- print(restaurant_map)
		clientevents.PlayerEvents.i_have_setup_restaurants.fire()
		-- -- table.clear(restaurant_map)
		-- print("setting it to nil....")
		-- -- restaurant_map = nil :: never

		--//TODO: THIS IS NOT GOOD. We should have a better way of letting the server know we
		-- have successfully completed all the client restaurant setups
		completed = true
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
