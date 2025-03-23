local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local events = require(ReplicatedStorage.common.events)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local __ = jecs.Wildcard

local function system()
	-- for i, player in events.IFinishedSettingUpRestaurantInitiially:query():server():iter() do
	-- 	local store = playerstore[player]
	-- 	store.has_setup_restaurant = true
	-- end

	for i, player in events.IFinishedSettingUpHousesInitiially:query():server():iter() do
		-- local store = playerstore[player]
		-- store.has_setup_house = true

		local store = playersetupconfig[player]
		store.house_setup.client_completed = true
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
