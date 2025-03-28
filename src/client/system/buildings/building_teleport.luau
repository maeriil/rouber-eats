local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

-- local cast_query =
-- 	world:query(c.CastStatus):with(c.TeleportZone):without(pairs.TPCooldown):cached()

local door_interaction_query = world
	:query(c.BasePart)
	:with(c.DoormatZone, c.Interacted)
	:without(pairs.InteractedCooldown)
	:cached()

local request_to_teleport = clientevents.Building.IWantToTeleportInOrOut
local function system()
	for i in door_interaction_query:iter() do
		local parent = world:parent(i)
		assert(
			parent ~= nil and world:contains(parent),
			`Parent entity for the door does not exist. This is a bug, investigate`
		)
		local serverid = world:get(parent, c.EntityId)
		assert(serverid, `The Server entity id does not exist for the building in client...`)

		--[[
			Since the doormat belongs to the building in exterior world, its telling server
			that it want ts to go to interior

			true = going to interior
			false = (player is in interior, going to exterior)

		]]
		local to_interior = world:has(parent, c.Exterior) and "exterior" or "interior"
		request_to_teleport.fire(serverid, to_interior :: never)

		world:set(i, pairs.InteractedCooldown, 2) -- So clients dont just spam request
		world:set(c.Client, pairs.InteractedCooldown, 0.25)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
