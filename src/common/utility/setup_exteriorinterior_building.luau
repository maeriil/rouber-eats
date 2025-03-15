local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local childof = require(script.Parent.childof)
local jecs = require(ReplicatedStorage.pkg.jecs)
local setup_door = require(script.Parent.setup_door)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function setup_exteriorinterior_house(model: Model, params: types.BuildingRemoteParams)
	-- If it is a exterior/interior building, then it most likely is a building player can go in. Exterior is the outside
	-- look and interior is the inside part of the building
	-- Typically, the interior of the building is somewhere else far away
	local exterior = model:FindFirstChild("Exterior") :: Model
	local interior = model:FindFirstChild("Interior") :: Model
	local parent = ref(model)
	-- Could use ref, but how would we cleanup?
	-- local interior_e = world:entity()
	-- local exterior_e = world:entity()
	local interior_e = ref(interior)
	local exterior_e = ref(exterior)

	world:set(parent, pair(c.EntityId, c.Interior), interior_e)
	world:set(parent, pair(c.EntityId, c.Exterior), exterior_e)
	world:set(parent, c.Model, model)

	local interior_root = interior.PrimaryPart :: Part
	-- local interior_door = interior:FindFirstChild("Door") :: Model
	-- local interior_doormat = interior_door.PrimaryPart :: Part
	world:add(interior_e, c.Interior)
	world:add(interior_e, childof(parent))
	world:set(interior_e, c.Model, interior)
	world:set(interior_e, c.PrimaryPart, interior_root)

	local exterior_root = exterior.PrimaryPart :: Part
	local exterior_door = exterior:FindFirstChild("DoorCore") :: Model
	local exterior_doormat = exterior_door.PrimaryPart :: Part
	world:add(exterior_e, childof(parent))
	world:add(exterior_e, c.Exterior)
	world:set(exterior_e, c.Model, exterior)
	world:set(exterior_e, c.PrimaryPart, exterior_root)

	--[[
		TODO: This is an ughhh, dont do this find another way
	]]
	if RunService:IsClient() then
		if not params.can_enter then
			world:add(interior_e, c.CannotOpen)
			world:add(interior_e, c.CannotTeleport)
			world:add(exterior_e, c.CannotOpen)
			world:add(exterior_e, c.CannotTeleport)
		end
	end

	setup_door(interior, interior_e)
	setup_door(exterior, exterior_e)

	-- A position of a interior/exterior building means the exterior's position. In particular,
	-- its the doormat's position, so we should use that
	--[[
		TODO: REFACTOR THIS BELOW GARBAGE CODE
	]]
	world:set(parent, c.Position, exterior_doormat.Position :: never)

	-- if RunService:IsServer() then
	-- 	local interior_touched = interior_doormat.Touched:Connect(function(part: BasePart)
	-- 		-- kinda bad, we should probably add to event queue something
	-- 		local player = opt_get_player(part)
	-- 		if not player then
	-- 			return
	-- 		end

	-- 		local e = ref(player)
	-- 		world:set(e, c.TeleportTo, exterior_doormat.CFrame)
	-- 	end)
	-- 	world:set(interior_e, c.Connection, interior_touched)

	-- 	local exterior_touched = exterior_root.Touched:Connect(function(part: BasePart)
	-- 		-- kinda bad, we should probably add to event queue something
	-- 		local player = opt_get_player(part)
	-- 		if not player then
	-- 			return
	-- 		end
	-- 		local e = ref(player)
	-- 		world:set(e, c.TeleportTo, interior_root.CFrame)
	-- 	end)

	-- 	world:set(interior_e, c.Connection, interior_touched)
	-- 	world:set(exterior_e, c.Connection, exterior_touched)
	-- end
end

return setup_exteriorinterior_house
