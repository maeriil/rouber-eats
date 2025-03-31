local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)
local p = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local add_delivery_cutscene = clientevents.Building.add_cutscene_to_house
local all_exteriors = world:query(c.EntityId):with(c.Exterior, pair(c.DoormatZone, __)):cached()
local function system()
	for _, _server_house_id in add_delivery_cutscene.iter() do
		local server_house_id = blink_conv.as_entity(_server_house_id)

		-- Find out the exterior house that contains this, and then add it to its DoorMatZone
		local found = false
		for exterior_id, mapped_server_id in all_exteriors:iter() do
			if mapped_server_id == server_house_id then
				local doormat_id = world:target(exterior_id, c.DoormatZone) :: t.Entity
				world:add(doormat_id, c.HasCutscene)
				world:add(doormat_id, c.HasOrderToBeDelivered)

				found = true
				break
			end
		end

		if not found then
			error(
				`Could not find a house with the server entity id {server_house_id} in client world... This is most likely a bug`
			)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
