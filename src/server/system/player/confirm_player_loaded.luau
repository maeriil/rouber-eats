local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)

local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	-- for client_id, client in world:query(c.Client):iter() do
	-- 	local configstore = playersetupconfig[client]
	-- 	if not configstore then
	-- 		continue
	-- 	end

	-- 	if configstore.loaded_in.server_sent then
	-- 		continue
	-- 	end

	-- 	configstore.loaded_in.server_sent = true
	-- 	request_player_load_in.fire(client, blink_conv.from_entity(client_id))
	-- end

	-- for _, player in response_player_load_in.iter() do
	-- 	local configstore = playersetupconfig[player]
	-- 	configstore.loaded_in.client_completed = true
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.WorldSetups,
	runConditions = {},
}
