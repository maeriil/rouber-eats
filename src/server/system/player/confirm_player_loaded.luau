local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)

local c = require(ReplicatedStorage.common.ecs.components)
local events = require(ReplicatedStorage.common.events)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	--system

	for client_id, client in world:query(c.Client):iter() do
		local configstore = playersetupconfig[client]
		if not configstore then
			continue
		end

		if configstore.loaded_in.server_sent then
			continue
		end

		configstore.loaded_in.server_sent = true
		events.PlayerLoadIn:send(client_id):to(client)
	end

	for _, player in events.IHaveLoadedIn:query():server():iter() do
		local configstore = playersetupconfig[player]
		configstore.loaded_in.client_completed = true
		warn(`player ={player.Name} has confirmed they have loaded in`)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.WorldSetups,
	runConditions = {},
}
