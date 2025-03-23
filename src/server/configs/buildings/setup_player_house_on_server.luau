local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local function setup_house_on_server(
	landlot: types.Entity,
	player_house: string,
	player: Player,
	interiormodel: Model
)
	local owner_id = ref(player)
	local interior_root = interiormodel.PrimaryPart
	assert(interior_root, `House {player_house}'s interior model does not have a primary part`)

	local house_id = world:entity()
	local interior_id, cleanup = ref(interiormodel)
	-- The exterior's model will not be stored in server
	local exterior_id = world:entity()
	local teleport_position = world:get(landlot, pairs.PlayerExteriorTPTransform) :: CFrame
	local exterior_doormat_pos = world:get(landlot, pairs.DoormatTransform) :: CFrame

	world:set(owner_id, c.Residence, house_id)
	world:add(owner_id, c.HouseOwner)

	world:set(landlot, c.OccupiedByPlayer, owner_id)
	world:set(landlot, c.Residence, house_id)
	world:remove(landlot, c.Vacant)

	world:set(house_id, c.House, player_house)
	world:set(house_id, pairs.BuildingInteriorId, interior_id)
	world:set(house_id, pairs.BuildingExteriorId, exterior_id)
	world:set(house_id, c.Name, player.Name)
	world:set(house_id, c.OccupiedByPlayer, owner_id)
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

	events.CreateHouse:send(house_id, exterior_doormat_pos, interiormodel, player_house, owner_id)

	return house_id
end

return setup_house_on_server
