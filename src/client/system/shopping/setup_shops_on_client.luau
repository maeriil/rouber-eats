local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basepartmap = require(ReplicatedStorage.client.store.basepartmap)
local clientgamedata = require(ReplicatedStorage.client.store.clientgamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)
local setup_door = require(ReplicatedStorage.common.configs.buildings.setup_door)
local store_item_list = require(ReplicatedStorage.common.configs.items)
local store_list = require(ReplicatedStorage.common.configs.store)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local attributes = require(ReplicatedStorage.types.attributes)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local instance_added = {}

CollectionService:GetInstanceAddedSignal(tags.Store):Connect(function(instance: Instance)
	local client_id_attribute = instance:GetAttribute(attributes.clientid)

	if client_id_attribute == nil then
		table.insert(instance_added, instance)
	end
end)

local instance_removed = {}
CollectionService:GetInstanceRemovedSignal(tags.Store):Connect(function(instance: Instance)
	--// Realistically they will never get destroyed so its okay
end)

--//TODO: move this to its own module
local function get_configurations(configuration: Instance)
	type Config = {
		item_id: string,
	}

	local item_id = configuration:GetAttribute("item_id")
	assert(
		item_id ~= nil and typeof(item_id) == "string",
		`item_id must exist and should be a string`
	)

	return {
		item_id = item_id,
	} :: Config
end

local function setup_store_to_client(store_folder: Folder, interior: Model, exterior: Model)
	local store_name = store_folder.Name
	local interior_primary = interior.PrimaryPart :: Part
	local exterior_priamry = exterior.PrimaryPart :: Part
	local store_config = store_list[store_name]
	assert(store_config, `Store with name {store_name} does not exist in config folder...`)

	local display_name = store_config.display_name
	local parent_id = store_config.id
	local interior_id = ref(interior)
	local exterior_id = ref(exterior)
	local interior_server_mapped_id = interior:GetAttribute(attributes.serverid) :: t.Entity
	local exterior_server_mapped_id = exterior:GetAttribute(attributes.serverid) :: t.Entity

	assert(
		interior_server_mapped_id == exterior_server_mapped_id,
		`Serverid Map at this point should match`
	)

	world:add(parent_id, c.Store)
	world:set(parent_id, c.Name, display_name)
	world:set(parent_id, p.EntityId(c.Interior), interior_id)
	world:set(parent_id, p.EntityId(c.Exterior), exterior_id)

	world:add(interior_id, c.Store)
	world:add(interior_id, c.Interior)
	world:set(interior_id, c.Parent, parent_id)
	world:set(interior_id, c.Name, display_name)
	world:set(interior_id, c.EntityId, interior_server_mapped_id)
	world:set(interior_id, c.Transform, interior_primary.CFrame)
	world:set(interior_id, c.Model, interior)

	world:add(exterior_id, c.Store)
	world:add(exterior_id, c.Exterior)
	world:set(exterior_id, c.Parent, parent_id)
	world:set(exterior_id, c.Name, display_name)
	world:set(exterior_id, c.EntityId, exterior_server_mapped_id)
	world:set(exterior_id, c.Transform, exterior_priamry.CFrame)
	world:set(exterior_id, c.Model, exterior)

	setup_door(interior, interior_id)
	setup_door(exterior, exterior_id)

	server_id_map.store_map[interior_server_mapped_id] = parent_id
	clientgamedata.store_map[parent_id] = store_config

	--//TODO: we need to iterate over each item as well and attach some kind of tag
	-- or call a setup items function or something
	local items = interior:FindFirstChild("items") :: Folder
	for _, item in items:GetChildren() do
		assert(item:IsA("Model"), `The Item must be a model`)
		assert(item.PrimaryPart, `The item must have a primary part`)
		local configuration = item:FindFirstChild("item_configuration")
		assert(
			configuration ~= nil,
			`Configuration for each item must exist, doesnt exist for {item.Name}`
		)

		local item_server_id = item:GetAttribute(attributes.serverid) :: t.Entity?
		assert(item_server_id, `Server attribute id for {item.Name} must exist by now`)

		local item_config = get_configurations(configuration)
		local details = store_item_list[item_config.item_id]
		assert(details ~= nil, `Details cannot be nil for {item.Name}`)

		local item_id = details.id

		world:set(item_id, c.Name, details.display_name)
		world:set(item_id, c.Parent, parent_id)
		world:set(item_id, c.Roubins, details.base_price)
		world:set(item_id, c.EntityId, item_server_id)
		world:add(item_id, c.Item)

		item:SetAttribute(attributes.clientid, item_id)
		item.PrimaryPart:SetAttribute(attributes.clientid, item_id)

		basepartmap[item.PrimaryPart] = item_id
		clientgamedata.item_map[item_id] = details
		server_id_map.item_map[item_server_id] = item_id
	end

	interior:SetAttribute(attributes.clientid, parent_id)
	exterior:SetAttribute(attributes.clientid, parent_id)
	store_folder:SetAttribute(attributes.clientid, parent_id)
end

local function system()
	local n = #instance_added

	for i = n, 1, -1 do
		local folder = instance_added[i]
		assert(
			folder:IsA("Folder"),
			`Every store of this tag must be of folder type as this allows us to group Interior/Exterior together`
		)

		local store_name = folder.Name
		local interior = folder:FindFirstChild("Interior") or folder:FindFirstChild("interior")
		local exterior = folder:FindFirstChild("Exterior") or folder:FindFirstChild("exterior")

		assert(
			interior and interior:IsA("Model"),
			`Interior does not exist for the store name {store_name}. Verify it exists and is a model`
		)
		assert(
			exterior and exterior:IsA("Model"),
			`Exterior does not exist for the store name {store_name}. Verify it exists and is a model`
		)

		local interior_primary = interior.PrimaryPart
		local exterior_priamry = exterior.PrimaryPart

		assert(interior_primary, `Interior's Priamry part of the store {store_name} does not exist`)
		assert(exterior_priamry, `Exterior's Priamry Part of the store {store_name} does not exist`)

		local interior_server_mapped_id = interior:GetAttribute(attributes.serverid)
		local exterior_server_mapped_id = exterior:GetAttribute(attributes.serverid)

		assert(
			interior_server_mapped_id ~= nil,
			`Server attribute for Interior must exist at runtime for store {store_name}`
		)
		assert(
			exterior_server_mapped_id ~= nil,
			`Server attribute for Exterior must exist at runtime for store {store_name}`
		)
		assert(
			interior_server_mapped_id == exterior_server_mapped_id,
			`Unless we have changed our logic, it must be the case that both interior and exterior server attribute should be same`
		)

		local items_folder = interior:FindFirstChild("items")
		assert(
			items_folder and items_folder:IsA("Folder"),
			`Interior must contain a folder called items`
		)

		print(`Client-sided, Setting up the store {store_name}`)
		setup_store_to_client(folder, interior, exterior)

		instance_added[i] = nil
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
