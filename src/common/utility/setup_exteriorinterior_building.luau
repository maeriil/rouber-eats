local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local opt_get_player = require(script.Parent.opt_get_player)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard
local ChildOf = jecs.ChildOf

local function setup_exteriorinterior_house(model: Model)
	-- If it is a exterior/interior building, then it most likely is a building player can go in. Exterior is the outside
	-- look and interior is the inside part of the building
	-- Typically, the interior of the building is somewhere else far away
	local exterior = model:FindFirstChild("Exterior") :: Model
	local interior = model:FindFirstChild("Interior") :: Model
	local parent = ref(model)
	local interior_e = world:entity() -- Could use ref, but how would we cleanup?
	local exterior_e = world:entity()

	world:set(parent, pair(c.EntityId, c.Interior), interior_e)
	world:set(parent, pair(c.EntityId, c.Exterior), exterior_e)
	world:set(parent, c.Model, model)

	local interior_root = interior.PrimaryPart :: Part
	local interior_door = interior:FindFirstChild("Door") :: Model
	local interior_doormat = interior_door.PrimaryPart :: Part
	world:add(interior_e, c.Interior)
	world:add(interior_e, pair(ChildOf, parent))
	world:set(interior_e, c.Model, interior)
	world:set(interior_e, c.PrimaryPart, interior_root)

	local exterior_root = exterior.PrimaryPart :: Part
	local exterior_door = exterior:FindFirstChild("Door") :: Model
	local exterior_doormat = exterior_door.PrimaryPart :: Part
	world:add(exterior_e, pair(ChildOf, parent))
	world:add(exterior_e, c.Exterior)
	world:set(exterior_e, c.Model, exterior)
	world:set(exterior_e, c.PrimaryPart, exterior_root)

	-- A position of a interior/exterior building means the exterior's position. In particular,
	-- its the doormat's position, so we should use that
	world:set(parent, c.Position, exterior_doormat.Position :: never)

	if RunService:IsServer() then
		local interior_touched = interior_doormat.Touched:Connect(function(part: BasePart)
			-- kinda bad, we should probably add to event queue something
			local player = opt_get_player(part)
			if not player then
				return
			end

			local e = ref(player)
			world:set(e, c.TeleportTo, exterior_doormat.CFrame)
		end)
		world:set(interior_e, c.Connection, interior_touched)

		local exterior_touched = exterior_root.Touched:Connect(function(part: BasePart)
			-- kinda bad, we should probably add to event queue something
			local player = opt_get_player(part)
			if not player then
				return
			end
			local e = ref(player)
			world:set(e, c.TeleportTo, interior_root.CFrame)
		end)

		world:set(interior_e, c.Connection, interior_touched)
		world:set(exterior_e, c.Connection, exterior_touched)
	end
end

return setup_exteriorinterior_house
