local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local function setup_house_on_server(
	landlot: types.Entity,
	npc_house: string,
	npc: Model,
	interiormodel: Model,
	initial_setup: boolean
)
	local owner_id = ref(npc)
	local interior_root = interiormodel.PrimaryPart
	assert(interior_root, `House {npc_house}'s interior model does not have a primary part`)

	local house_id = world:entity()
	local interior_id, cleanup = ref(interiormodel)
	-- The exterior's model will not be stored in server
	local exterior_id = world:entity()
	local teleport_position = world:get(landlot, pairs.PlayerExteriorTPTransform) :: CFrame
	local exterior_doormat_pos = world:get(landlot, pairs.DoormatTransform) :: CFrame

	world:set(owner_id, c.Residence, house_id)

	world:set(landlot, c.OccupiedByNPC, owner_id)
	world:set(landlot, c.Residence, house_id)
	world:remove(landlot, c.Vacant)

	world:set(house_id, c.House, npc_house)
	world:set(house_id, pairs.BuildingInteriorId, interior_id)
	world:set(house_id, pairs.BuildingExteriorId, exterior_id)
	world:set(house_id, c.Name, npc.Name)
	world:set(house_id, c.OccupiedByNPC, owner_id)
	world:set(house_id, c.Parent, landlot)

	world:set(interior_id, c.Parent, house_id)
	world:set(interior_id, c.Model, interiormodel)
	world:set(interior_id, c.PrimaryPart, interior_root)
	world:set(interior_id, c.Transform, interior_root.CFrame)
	world:set(interior_id, c.Cleanup, cleanup)
	world:add(interior_id, c.Interior)

	world:set(exterior_id, c.Parent, house_id)
	world:set(exterior_id, c.Transform, teleport_position)
	world:add(exterior_id, c.Exterior)

	if not initial_setup then
		-- We only fire the remote event if it isn't initial setup.
		-- Initial setup is when server starts initially, and there are no players
		events.CreateHouse:send(house_id, exterior_doormat_pos, interiormodel, npc_house, owner_id)
	end

	return house_id
end

return setup_house_on_server
