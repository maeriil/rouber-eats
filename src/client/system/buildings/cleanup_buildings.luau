local ReplicatedStorage = game:GetService("ReplicatedStorage")
local cached = require(ReplicatedStorage.common.ecs.cached)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)

local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for _, serverid in events.DeleteHouse:query():client():iter() do
		for clientid, mapped_serverid, cleanup in cached.iterate_cleanup:iter() do
			if mapped_serverid == serverid then
				cleanup()
				world:delete(clientid)
			end
		end
	end

	for _, serverid in events.DeleteRestaurant:query():client():iter() do
		for clientid, mapped_serverid, cleanup in cached.iterate_cleanup:iter() do
			if mapped_serverid == serverid then
				cleanup()
				world:delete(clientid)
			end
		end
	end

	for _, serverid in events.DeleteApartment:query():client():iter() do
		for clientid, mapped_serverid, cleanup in cached.iterate_cleanup:iter() do
			if mapped_serverid == serverid then
				cleanup()
				world:delete(clientid)
			end
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
