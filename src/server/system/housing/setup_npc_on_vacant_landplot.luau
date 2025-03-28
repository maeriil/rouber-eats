local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local buildings_map = require(ReplicatedStorage.common.configs.buildings.buildings_map)
local jecs = require(ReplicatedStorage.pkg.jecs)
local serverevents = require(ServerScriptService.server.serverevents)
local t = require(ReplicatedStorage.types)

local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local c = require(ReplicatedStorage.common.ecs.components)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
   Here, we iterate over all the vacant landplots that isn't claimed by any players.
   We setup the NPC and their house and send it to everyone in the server
]]
local all_unoocupied_lands = world
	:query(pairs.DoormatTransform, pairs.PlayerExteriorTPTransform)
	:with(c.LandPlot, c.Vacant)
	:without(pairs.ClaimedBy)
	:cached()
local fallback_house = "House_BasicHouse" :: t.BuildingsType

--//TODO DO NOT DO THIS LMFAO, REFACTOR IT...
local order = next_order()
local noob = workspace:FindFirstChild("Noob") :: Model
-- local runtime_folder = ReplicatedStorage.runtimeasset :: Folder
-- local runtime_npc = runtime_folder:FindFirstChild("npc") :: Folder

if not noob then
	error(`!!!! TODO: We need to store all the Noob models somewhere properly`)
else
	warn(`!!!! TODO: We need to store all the Noob models somewhere properly`)
end

local function create_noob(next_order_value: number)
	local npc = noob:Clone()
	npc.Name = `Noob #{next_order_value}`
	npc.Parent = workspace.GameNPC

	return npc
end

local request_create_house_owner = serverevents.Building.create_house_owner
local request_create_house = serverevents.Building.create_house
local function system()
	for plot_id, exterior_doormat_cf, player_tp_cf in all_unoocupied_lands:iter() do
		local next_order_value = order()
		local npc = create_noob(next_order_value)
		local is_npc = true
		local root = npc.PrimaryPart
		assert(root, `NPC {npc.Name} does not have primary part defined. This is a bug`)

		local npc_id, cleanup_npc = ref(npc)
		world:set(npc_id, c.Model, npc)
		world:set(npc_id, c.Name, npc.Name)
		world:set(npc_id, c.PrimaryPart, root)
		world:set(npc_id, c.Cleanup, cleanup_npc)
		world:add(npc_id, c.HouseNPC)
		world:add(npc_id, c.HouseOwner)

		local house_model_readonly = buildings_map[fallback_house]
		assert(
			house_model_readonly ~= nil,
			`Building model with name {fallback_house} does not exist. This is a bug`
		)
		local interior_model = house_model_readonly.Interior:Clone()
		local interior_root = interior_model.PrimaryPart
		assert(
			interior_root ~= nil,
			`House {fallback_house}'s interior model does not have a primary part`
		)
		interior_model:PivotTo(CFrame.new(0, 100 * next_order_value, 50 * next_order_value))
		interior_model.Name = `{npc.Name} Interior`
		interior_model.Parent = workspace.Interior

		local house_id = world:entity()
		local interior_id, interior_cleanup = ref(interior_model)
		local exterior_id = world:entity()

		world:set(npc_id, c.Residence, house_id)
		world:add(npc_id, c.HouseOwner)

		-- Parent house setups on server. We simply keep track of the interior and exterior house
		-- and the parent its "renting" from
		world:set(house_id, c.House, fallback_house)
		world:set(house_id, pairs.BuildingInteriorId, interior_id)
		world:set(house_id, pairs.BuildingExteriorId, exterior_id)
		world:set(house_id, c.Name, npc.Name)
		world:set(house_id, c.OccupiedByNPC, npc_id)
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

		request_create_house_owner.fire_all(blink_conv.from_entity(npc_id), npc, is_npc)
		request_create_house.fire_all(
			blink_conv.from_entity(house_id),
			exterior_doormat_cf,
			interior_model,
			fallback_house,
			blink_conv.from_entity(npc_id)
		)

		-- It is no longer vacant, mark it as such
		world:set(plot_id, c.OccupiedByNPC, npc_id)
		world:set(plot_id, c.Residence, house_id)
		world:remove(plot_id, pairs.ClaimedBy)
		world:remove(plot_id, c.Vacant)

		-- warn("Completed in drawing out the interior landplot")
	end
end

-- local function system() end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.Housing.HousingUpdate,
	runConditions = {},
}
