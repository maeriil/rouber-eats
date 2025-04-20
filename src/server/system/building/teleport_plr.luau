local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local teleport_player_event = require(ReplicatedStorage.common.events.teleport_player_event)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local teleport = world:query(c.Model, c.TeleportTo, c.PrimaryPart):without(p.TPCooldown):cached()

local teleport_event_from_client = teleport_player_event.from_client()
local function system()
	for _, player, _building_id, curr_building in teleport_event_from_client.iter() do
		local building_id = (_building_id :: never) :: types.Entity
		if not building_id or not world:contains(building_id) then
			local error_msg = `The specified building id = {building_id} does not exist. Aborting request`
			warn(error_msg)
			-- events.teleport:FireClient(player, false, error_msg)
			teleport_player_event.to_client(player, {
				success = false,
				error_msg = error_msg,
			})
			continue
		end

		local e = ref(player)
		local interior_id = world:exists_get(building_id, p.EntityId(c.Interior))
		local exterior_id = world:exists_get(building_id, p.EntityId(c.Exterior))

		-- For that, we need to know whether a player is outside or inside
		-- We also need to store the exterior position of the building in our server, which we don't right now
		-- It should be some kind of boolean check i think
		-- Typically, these aren't very sensitive stuff, but if later on we need toimplemetn things like
		-- only specific players can enter and etc, we would need to add validations here

		--[[

		We need to use this, which will yield until it succeds or fails. While this is doing, we need to
		send to client letting them know that we are loading this area, aka a loading screen
		player:RequestStreamAroundAsync(destination.Position)
		Once it completes, we fire to client letting them know to remove the loading screen

		]]

		local going_interior = curr_building

		if going_interior then
			local destination = world:get(interior_id, c.Transform) :: CFrame
			world:set(e, c.TeleportTo, destination)

			teleport_player_event.to_client(player, {
				success = true,
				error_msg = "",
			}, building_id, true)
		else
			local destination = world:get(exterior_id, c.Transform) :: CFrame
			world:set(e, c.TeleportTo, destination)

			teleport_player_event.to_client(player, {
				success = true,
				error_msg = "",
			}, building_id, false)
		end
	end

	for i, model, cf, hrp in teleport:iter() do
		model:PivotTo(cf + Vector3.new(0, hrp.Size.Y / 2, 0))
		world:remove(i, c.TeleportTo)
		world:set(i, p.TPCooldown, 1)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
