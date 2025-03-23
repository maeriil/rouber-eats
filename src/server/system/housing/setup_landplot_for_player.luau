local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local buildings_map = require(ReplicatedStorage.common.configs.buildings.buildings_map)
local jecs = require(ReplicatedStorage.pkg.jecs)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)

local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local order = next_order()

-- Ideally, i dont want to use this way... we will have to see
-- local runtime_folder = ReplicatedStorage.runtimeasset :: Folder
-- local runtime_npc = runtime_folder:FindFirstChild("npc") :: Folder

local function clone_player_character(client: Player, client_id: types.Entity)
	local character = world:get(client_id, c.Model)
	assert(character ~= nil, "Character model must exist by now")
	assert(character.PrimaryPart ~= nil, "Character Primary Part must exist by now")

	-- local char = character:Clone()
	local char = character
	-- char.Parent = workspace

	return char
end

--[[
   Here is where we send all the clients about our new player's plot. Similar to other functions
   we first send the HouseOwner, then we send the House details such as info on what kind of
   exterior and the interior model

   It is guaranteed that the players data has loaded at this point, otherwise we wouldn't have
   marked it as Claimed. Also, NPC will never claim a plot, so its only players
]]
local empty_land = world
	:query(pairs.PlayerExteriorTPTransform, pairs.DoormatTransform, pairs.ClaimedBy)
	:with(c.Vacant)
	:cached()
local function system()
	for plot_id, player_tp_cf, exterior_doormat_cf, client_id in empty_land:iter() do
		local player = world:get(client_id, c.Client) :: Player
		local character = clone_player_character(player, client_id)
		local datastore = playerdatastore[player]
		local is_npc = false
		local house_type = datastore.housetype
		local interior_house_model_original = buildings_map[house_type]
		assert(
			interior_house_model_original ~= nil,
			`Building model with name {house_type} does not exist. This is a bug`
		)
		local interior_model = interior_house_model_original.Interior:Clone()
		local interior_root = interior_model.PrimaryPart
		assert(interior_root ~= nil, `House {house_type}'s interior model does not have a primary part`)
		--//TODO: DO NOT DO THIS LMFAO
		interior_model:PivotTo(CFrame.new(0, -100 * order(), 50 * order()))
		interior_model.Name = `{character.Name} Interior`
		interior_model.Parent = workspace.Interior

		local house_id = world:entity()
		local interior_id, interior_cleanup = ref(interior_model)
		local exterior_id = world:entity()

		world:set(client_id, c.Residence, house_id)
		world:add(client_id, c.HouseOwner)

		-- Parent house setups on server. We simply keep track of the interior and exterior house
		-- and the parent its "renting" from
		world:set(house_id, c.House, house_type)
		world:set(house_id, pairs.BuildingInteriorId, interior_id)
		world:set(house_id, pairs.BuildingExteriorId, exterior_id)
		world:set(house_id, c.Name, player.Name)
		world:set(house_id, c.OccupiedByPlayer, client_id)
		world:set(house_id, c.Parent, plot_id)

		-- The interior of the house is server owned. This is why we create it on server. But we still
		-- send it to the client so they can worry about rendering it on their side
		world:set(interior_id, c.Parent, house_id)
		world:set(interior_id, c.Model, interior_model)
		world:set(interior_id, c.PrimaryPart, interior_root)
		world:set(interior_id, c.Transform, interior_root.CFrame)
		world:set(interior_id, c.Cleanup, interior_cleanup)
		world:add(interior_id, c.Interior)

		-- The exterior of the house is competely drawn by the client. I could care less about what they
		-- do with it. Only they will be able to view changes if they end up modify it anyway. We hover
		-- still spawn an entity in server beacuse we want to quickly teleport players in and out of house
		world:set(exterior_id, c.Parent, house_id)
		world:set(exterior_id, c.Transform, player_tp_cf)
		world:add(exterior_id, c.Exterior)

		-- When we first setup the client in the server, we should send the mapped client's server id
		-- So that on the client side, player can lookup the EntityId to determine that they are local
		-- player
		events.CreateHouseOwner:send(client_id, character.Name, is_npc)
		print(`When we setup landplot, we are sending {house_id}`)
		events.CreateHouse:send(house_id, exterior_doormat_cf, interior_model, house_type, client_id)

		-- It is no longer vacant, mark it as such
		world:set(plot_id, c.OccupiedByPlayer, client_id)
		world:set(plot_id, c.Residence, house_id)
		world:remove(plot_id, pairs.ClaimedBy)
		world:remove(plot_id, c.Vacant)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.Housing.HousingUpdate,
	runConditions = {},
}
