local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local request_map_setup = serverevents.PlayerEvents.setup_map_on_join
local response_map_setup = serverevents.PlayerEvents.i_have_setup_map
local function system()
	for i, player in world:query(c.Client):iter() do
		local store = playersetupconfig[player]
		if not store or store.map_setup.server_sent then
			continue
		end
		if not player.PlayerGui then
			continue
		end

		local map_gui = player.PlayerGui:FindFirstChild("MAP")
		if not map_gui then
			warn(`map gui was not found`)
			continue
		end

		local map = world:get(c.Map, c.Map)
		if not map then
			--[[
	      Technically we should never reach this point. However, it probably just means player
	      loaded earlier than server has setup, which is typically in studio.
	      We can just halt until map is setup then move on
	    ]]
			continue
		end

		store.map_setup.server_sent = true
		warn(`Setting up the map for client...`)
		local cloned_map = map:Clone()
		cloned_map.Parent = map_gui

		request_map_setup.fire(player)
	end

	for _, player in response_map_setup.iter() do
		local store = playersetupconfig[player]
		store.map_setup.client_completed = true
	end
end

-- local function system() end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.WorldSetups,
	runConditions = {},
}
