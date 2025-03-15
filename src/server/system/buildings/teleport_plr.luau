-- When players come in touch with a door, they will fire to server
-- in server, if a player can enter the building, we will teleport them to the dest location

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local teleport =
	world:query(c.Model, c.TeleportTo, c.PrimaryPart):without(pairs.TPCooldown):cached()
local function system()
	for _, player, building in events.IWantToTeleportInOrOut:query():server():iter() do
		if not building then
			continue
		end

		local e = ref(player)
		local curr_build_id = ref(building)
		local parent = world:parent(curr_build_id)
		if parent == nil or not world:contains(parent) then
			task.spawn(error, `Debug this... this is really weird`)
			continue
		end

		local is_current_interior = world:has(curr_build_id, c.Interior)
		if is_current_interior then
			-- local exterior = world:target(parent, c.Exterior) :: t.Entity
			-- WHY DID I WRITE IT LIKE THIS AND NOT TARGET??
			local exterior = world:get(parent, pair(c.EntityId, c.Exterior)) :: types.Entity
			local exterior_model = world:get(exterior, c.Model) :: Model
			local exterior_door = exterior_model:FindFirstChild("DoorCore") :: Model
			local exterior_doormat = exterior_door.PrimaryPart :: Part

			world:set(e, c.TeleportTo, exterior_doormat.CFrame)
		else
			-- local interior = world:target(parent, c.Interior) :: t.Entity
			local interior = world:get(parent, pair(c.EntityId, c.Interior)) :: types.Entity
			local interior_mat = world:get(interior, c.PrimaryPart) :: Part

			world:set(e, c.TeleportTo, interior_mat.CFrame)
		end
	end

	-- for i, model, cf in world:query(c.Model, c.TeleportTo):iter() do
	for i, model, cf, hrp in teleport:iter() do
		model:PivotTo(cf + Vector3.new(0, hrp.Size.Y / 2, 0))
		world:remove(i, c.TeleportTo)
		world:set(i, pairs.TPCooldown, 1)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
