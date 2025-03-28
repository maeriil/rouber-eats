local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)
local __ = jecs.Wildcard

local response_house_setup = serverevents.PlayerEvents.i_have_setup_houses
local function system()
	for _, player in response_house_setup.iter() do
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
