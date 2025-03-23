local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local teleport =
	world:query(c.Model, c.TeleportTo, c.PrimaryPart):without(pairs.TPCooldown):cached()
local function system()
	for _, player, building_id, going_interior in
		events.IWantToTeleportInOrOut:query():server():iter()
	do
		if not building_id or not world:contains(building_id) then
			warn(`That building id does not exist!`)
			warn(`building id = {building_id}`)
			continue
		end

		local e = ref(player)
		local interior_id = world:get(building_id, pairs.BuildingInteriorId)
		local exterior_id = world:get(building_id, pairs.BuildingExteriorId)

		-- For that, we need to know whether a player is outside or inside
		-- We also need to store the exterior position of the building in our server, which we don't right now
		-- It should be some kind of boolean check i think
		-- Typically, these aren't very sensitive stuff, but if later on we need toimplemetn things like
		-- only specific players can enter and etc, we would need to add validations here

		assert(interior_id ~= nil, `Interior id must exist for the building`)
		assert(exterior_id ~= nil, `Exterior id must exist for the building`)

		if going_interior then
			local destination = world:get(interior_id, c.Transform) :: CFrame
			world:set(e, c.TeleportTo, destination)
		else
			local destination = world:get(exterior_id, c.Transform) :: CFrame
			world:set(e, c.TeleportTo, destination)
		end
	end

	for i, model, cf, hrp in teleport:iter() do
		model:PivotTo(cf + Vector3.new(0, hrp.Size.Y / 2, 0))
		world:remove(i, c.TeleportTo)
		world:set(i, pairs.TPCooldown, 1)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
