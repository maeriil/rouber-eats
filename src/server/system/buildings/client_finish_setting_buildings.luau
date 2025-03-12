local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for i, player in events.IFinishedSettingUpRestaurantInitiially:query():server():iter() do
		local store = playerstore[player]
		store.has_setup_restaurant = true
	end

	for i, player in events.IFinishedSettingUpHousesInitiially:query():server():iter() do
		local store = playerstore[player]
		store.has_setup_house = true
	end

	for i, player in events.IFinishedSettingUpAptsInitiially:query():server():iter() do
		local store = playerstore[player]
		store.has_setup_apartments = true
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
