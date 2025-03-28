local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local gamedata = require(ServerScriptService.server.store.gamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local p = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local restaurant_list = require(ReplicatedStorage.common.configs.restaurant)

local attributes = require(ReplicatedStorage.types.attributes)
local c = require(ReplicatedStorage.common.ecs.components)
local planck = require(ReplicatedStorage.pkg.planck)
local ref = require(ReplicatedStorage.common.ecs.ref)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  This needs to run initially before the map is unloaded to the server storage

  We don't care about where the restuarant is located in the map, we can just ensure we have
  some tag assigned to the Restuarant. Honestly, i think the interior should be grouped together
  with the exterior, and we can just kinda move the interior to the bottom of the map.

  Query all models with the tag, and add to world. Add relevant attributes to the restuarant.
  The goal is to not need to do any of the replicating stuff. Figure out what additional stuff
  we would need to send about the restuarants to the player. Currently there is none

  For all the static objects in the game, or in this case the restuarant we will follow the format of

  Restaurant/
    <name of the restuarant>/
      Interior(Model)
      Exterior(Model)

  Folders can be assigned the tags as well. The only thing is that we may/may not use the Restuarant folder,
  that is, we may not always parent it Restaurant folder, especially if we have more maps in future
  For now, its fine, but ill still use CollectionService instead
]]

local function system()
	local instances = CollectionService:GetTagged(tags.Restaurant)

	for _, folder in instances do
		assert(
			folder:IsA("Folder"),
			`Every restuarant must be of folder type as this allows us to group Interior/Exterior together`
		)

		local restaurant_name = folder.Name
		local restaurant_config = restaurant_list[restaurant_name]
		assert(
			restaurant_config,
			`Restaurant with name {restaurant_name} does not exist in config folder...`
		)

		local restaurant_id = restaurant_config.id
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

		--[[
      Each restaurant follows the same hierarchical as the housing and store. In our world we model it as
      Restaurant {
        Interior Entity {}
        Exterior Entity {}
      }

      The server and client entity id we set for both interior/exterior attribute is of its parent
      restaurant. This is beacuse the teleportation system already assumes that only the parent id is specified.
      We also want to keep track of both interior/exterior in server in case (?)

      Furthermore, we need to get the root, and the transform position. Root is not that needed tbh
      but transform is what we use to teleport players in and out. In our case, this is the primary part
      of the buidling
    ]]

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

		warn(`Setting up the restaurant {restaurant_name} to the world @ Server world`)

		local parent_id = restaurant_id
		local interior_id = ref(interior)
		local exterior_id = ref(exterior)
		local display_name = restaurant_config.display_name

		world:add(parent_id, c.Restaurant)
		world:set(parent_id, c.Name, display_name)
		world:set(parent_id, p.BuildingInteriorId, interior_id)
		world:set(parent_id, p.BuildingExteriorId, exterior_id)

		world:add(interior_id, c.Restaurant)
		world:add(interior_id, c.Interior)
		world:set(interior_id, c.Parent, parent_id)
		world:set(interior_id, c.Name, display_name)
		world:set(interior_id, c.Transform, interior_primary.CFrame)
		-- They are guaranteed to always exist, we don't need to add cleanup, just directly index
		-- and remove it in the end
		-- world:set(interior_id, c.Cleanup, interior_cleanup)

		world:add(exterior_id, c.Restaurant)
		world:add(exterior_id, c.Exterior)
		world:set(exterior_id, c.Parent, parent_id)
		world:set(exterior_id, c.Name, display_name)
		world:set(exterior_id, c.Transform, exterior_priamry.CFrame)
		-- world:set(interior_id, c.Cleanup, exterior_cleanup)

		--[[

		  Lastly, we want to set the server entity id attribute to both of these models and folder
	    Attributes will replicate so the client will just need to grab them runtime and add them to world
      TODO we could actually move this to the OnSet hook for Model and Folder
      we can add that small enhancement later tbh

    ]]

		gamedata.restaurant_map[restaurant_id] = restaurant_config

		-- We provide parent entity id for all instances
		interior:SetAttribute(attributes.serverid, parent_id)
		exterior:SetAttribute(attributes.serverid, parent_id)
		folder:SetAttribute(attributes.serverid, parent_id)
	end

	table.clear(restaurant_list)
	restaurant_list = nil :: never
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.ServerInitialize.BuildingSetup,
	runConditions = {
		planck.runOnce(),
	},
}
