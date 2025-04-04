local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local gamedata = require(ServerScriptService.server.store.gamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local store_item_list = require(ReplicatedStorage.common.configs.items)
local store_list = require(ReplicatedStorage.common.configs.store)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local attributes = require(ReplicatedStorage.types.attributes)
local planck = require(ReplicatedStorage.pkg.planck)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  Behaves very similar to the restaurants. We run initially before the map is moved to setup
  All we do is spawn the required entities, and then add information and adjust attributes.
  Unlike the restaurant, we also need to attach the entity to the items as well.

  We first query for the store, with the store tags, then the structure will be as follows

  <store name>/
    Interior (Model)/
      items (Folder)/
    Exterior (Model)/

  Something to note is that some store may not have interior. And thats because it might just
  be an NPC or a exterior location, we would use StoreNoInterior for this. Then the structure
  will be as follows

  <store name>/
    Exterior (Model) ???
    items (Folder)
]]

--//TODO: move this to its own module
local function get_configurations(configuration: Configuration)
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

local function setup_interior_exterior_store()
	local instances = CollectionService:GetTagged(tags.Store)

	for _, folder in instances do
		assert(
			folder:IsA("Folder"),
			`Every store must be of folder type as this allows us to group Interior/Exterior together`
		)

		local store_name = folder.Name
		local store_config = store_list[store_name]
		assert(store_config, `Store with name {store_name} does not exist in config folder...`)

		local store_id = store_config.id
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

		warn(`Setting up the store {store_name} to the world @ Server world`)

		local parent_id = store_id
		local interior_id = ref(interior)
		local exterior_id = ref(exterior)
		local display_name = store_config.display_name

		world:add(parent_id, c.Store)
		world:set(parent_id, c.Name, display_name)
		world:set(parent_id, p.BuildingInteriorId, interior_id)
		world:set(parent_id, p.BuildingExteriorId, exterior_id)

		world:add(interior_id, c.Store)
		world:add(interior_id, c.Interior)
		world:set(interior_id, c.Parent, parent_id)
		world:set(interior_id, c.Name, display_name)
		world:set(interior_id, c.Transform, interior_primary.CFrame)

		world:add(exterior_id, c.Store)
		world:add(exterior_id, c.Exterior)
		world:set(exterior_id, c.Parent, parent_id)
		world:set(exterior_id, c.Name, display_name)
		world:set(exterior_id, c.Transform, exterior_priamry.CFrame)

		gamedata.store_map[store_id] = store_config
		interior:SetAttribute(attributes.serverid, parent_id)
		exterior:SetAttribute(attributes.serverid, parent_id)
		folder:SetAttribute(attributes.serverid, parent_id)

		-- We need to go through the items now

		local items = interior:FindFirstChild("items")
		assert(items ~= nil and items:IsA("Folder"), `Items for the interior of the store must exist`)

		for _, item in items:GetChildren() do
			assert(item:IsA("Model"), `The Item must be a model`)
			assert(item.PrimaryPart, `The item must have a primary part`)

			local configuration = item:FindFirstChild("item_configuration")
			assert(
				configuration ~= nil,
				`Configuration for each item must exist, doesnt exist for {item.Name}`
			)
			local item_config = get_configurations(configuration)

			-- Read the configuration and map it to the appropriate item id
			local details = store_item_list[item_config.item_id]
			assert(details ~= nil, `Details cannot be nil for {item.Name}`)

			local item_id = details.id

			world:set(item_id, c.Name, details.display_name)
			world:set(item_id, c.Parent, store_id)
			world:set(item_id, c.Coins, details.base_price)
			world:add(item_id, c.Item)

			item:SetAttribute(attributes.serverid, item_id)
			item.PrimaryPart:SetAttribute(attributes.serverid, item_id)
		end
	end
end

local function setup_exterior_store() end

local function system()
	setup_interior_exterior_store()
	setup_exterior_store()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {
		planck.runOnce(),
	},
}
