local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
--[[
  Something to note is that this will only be really called once initially when server starts
  The server will loop through the interiors folder, and setup a restaurant for each one

]]

local function setup_restaurant_on_server(interiormodel: Model, exteriormodel: Model)
	local name = interiormodel.Name
	local interior_root = interiormodel.PrimaryPart
	assert(interior_root, `Restaurant {name}'s interior model does not have a primary part`)

	local door_core = exteriormodel:FindFirstChild("DoorCore") :: Model?
	assert(door_core, `Door core must exist on the restaurant {name}`)
	local exterior_doormat = door_core.PrimaryPart
	assert(exterior_doormat, `Door core must have a primary part, which is the doormat`)

	local restaurant_id = world:entity()
	local interior_id = ref(interiormodel)
	-- We don't keep track of the exterior model. However, we do keep track of Doormat's Position
	local exterior_id = world:entity()

	world:add(restaurant_id, c.Restaurant)
	world:set(restaurant_id, pairs.BuildingInteriorId, interior_id)
	world:set(restaurant_id, pairs.BuildingExteriorId, exterior_id)
	world:set(restaurant_id, c.Name, name)

	world:set(interior_id, c.Parent, restaurant_id)
	world:set(interior_id, c.Model, interiormodel)
	world:set(interior_id, c.PrimaryPart, interior_root)
	world:set(interior_id, c.Transform, interior_root.CFrame)
	world:add(interior_id, c.Interior)

	world:set(exterior_id, c.Parent, restaurant_id)
	world:set(exterior_id, c.Transform, exterior_doormat.CFrame)
	world:add(exterior_id, c.Exterior)

	return restaurant_id
end

return setup_restaurant_on_server
