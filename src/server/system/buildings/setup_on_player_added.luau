local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local cached = require(ReplicatedStorage.common.ecs.cached)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local events = require(ReplicatedStorage.common.events)
local __ = jecs.Wildcard

local function can_enter_house(player: Player, house: Model)
	return true
end

local function can_enter_apartment(player: Player, house: Model)
	return true
end

local function can_enter_restaurant(player: Player, restaurant: Model)
	return true
end

local function system()
	for player, store in playerstore do
		if not store.sent_req_to_setup_house then
			task.spawn(function()
				local entities = {} :: { types.Entity }
				local models = {} :: { Model }
				local params = {} :: { types.BuildingRemoteParams }

				for i, model in cached.get_houses:iter() do
					table.insert(entities, i)
					table.insert(models, model)
					table.insert(params, {
						can_enter = can_enter_house(player, model),
					})
				end

				events.BulkCreateHouses:send(models, entities, params):to(player)
				store.sent_req_to_setup_house = true
			end)
		end

		if not store.sent_req_to_setup_apartments then
			task.spawn(function()
				local entities = {} :: { types.Entity }
				local models = {} :: { Model }
				local params = {} :: { types.BuildingRemoteParams }

				for i, model in cached.get_apartments:iter() do
					table.insert(entities, i)
					table.insert(models, model)
					table.insert(params, {
						can_enter = can_enter_apartment(player, model),
					})
				end

				events.BulkCreateApartments:send(models, entities, params):to(player)
				store.sent_req_to_setup_apartments = true
			end)
		end

		if not store.sent_req_to_setup_restaurant then
			task.spawn(function()
				local entities = {} :: { types.Entity }
				local models = {} :: { Model }
				local params = {} :: { types.BuildingRemoteParams }

				for i, model in cached.get_restaurants:iter() do
					table.insert(entities, i)
					table.insert(models, model)
					table.insert(params, {
						can_enter = can_enter_restaurant(player, model),
					})
				end

				events.BulkCreateRestaurants:send(models, entities, params):to(player)
				store.sent_req_to_setup_restaurant = true
			end)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
