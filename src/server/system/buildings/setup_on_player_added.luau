local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local cached = require(ReplicatedStorage.common.ecs.cached)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local ChildOf = jecs.ChildOf
local pair = jecs.pair
local __ = jecs.Wildcard

local function system()
	for player, store in playerstore do
		if store.has_setup_residence then
			continue
		end

		task.spawn(function()
			-- We dont want to block the main thread
			-- for e, model, res_type in world:query(c.Model, c.Residence):iter() do
			-- 	-- events.SetupResidence:send(model, res_type):to(player)
			-- end
			print(">> Firing all the buildings to the client ", player.Name)

			for i, model in cached.get_apartments:iter() do
				events.CreateApartment:send(model, i):to(player)
			end
			for i, model in cached.get_houses:iter() do
				events.CreateHouse:send(model, i):to(player)
			end
			for i, model in cached.get_restaurants:iter() do
				events.CreateRestaurant:send(model, i):to(player)
			end
		end)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
