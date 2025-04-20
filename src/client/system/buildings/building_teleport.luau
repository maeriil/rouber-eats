local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local t = require(ReplicatedStorage.types)
local teleport_player_event = require(ReplicatedStorage.common.events.teleport_player_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local door_interaction_query = world
	:query(c.BasePart)
	:with(c.DoormatZone, c.Interacted)
	:without(pairs.InteractedCooldown)
	:cached()

-- local all_exterior_models = world:query(c.Model):with(c.Exterior):cached()
local teleport_response = teleport_player_event.from_server()
local function on_server_teleport_handle()
	-- for _, result, interior_id, going_interior in teleport_response.iter() do
	-- 	if not result.success then
	-- 		warn(result.error_msg)
	-- 	else
	-- 		if going_interior then
	-- 			for _, model in all_exterior_models:iter() do
	-- 				model.Parent = nil
	-- 			end
	-- 		else
	-- 			-- How do we know what their parent position is? We could keep track of it ig?
	-- 			for _, model in all_exterior_models:iter() do
	-- 				model.Parent = workspace
	-- 			end
	-- 		end
	-- 	end
	-- end
end

local function system()
	for i in door_interaction_query:iter() do
		local parent = world:parent(i)
		assert(
			parent ~= nil and world:contains(parent),
			`Parent entity for the door does not exist. This is a bug, investigate`
		)
		local serverid = world:exists_get(parent, c.EntityId)

		--[[
			Since the doormat belongs to the building in exterior world, its telling server
			that it want ts to go to interior

			true = going to interior
			false = (player is in interior, going to exterior)

		]]
		local to_interior = world:has(parent, c.Exterior)
		teleport_player_event.to_server(serverid :: t.Entity, to_interior)

		world:set(i, pairs.InteractedCooldown, 2) -- So clients dont just spam request
		world:set(c.Client, pairs.InteractedCooldown, 0.25)
	end
	on_server_teleport_handle()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
