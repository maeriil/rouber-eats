local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	-- for i, player in world:query(c.Client):iter() do
	-- 	local store = playerstore[player]
	-- 	if not store or store.sent_req_to_setup_map then continue end
	-- 	if not player.PlayerGui then continue end

	-- 	local map_gui = player.PlayerGui:FindFirstChild("MAP")
	-- 	if not map_gui then
	-- 		warn(`map gui was not found`)
	-- 		continue
	-- 	end

	-- 	local map = world:get(c.Map, c.Map)
	-- 	if not map then
	-- 		--[[
	--       Technically we should never reach this point. However, it probably just means player
	--       loaded earlier than server has setup, which is typically in studio.
	--       We can just halt until map is setup then move on
	--     ]]
	-- 		continue
	-- 	end

	-- 	local cloned_map = map:Clone()
	-- 	cloned_map.Parent = map_gui

	-- 	events.SetupMapOnJoin:send():to(player)
	-- 	store.sent_req_to_setup_map = true
	-- end

	-- for _, player in events.IHaveSetupMapToWorkspace:query():server():iter() do
	-- 	local store = playerstore[player]
	-- 	store.has_setup_game_map = true
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.WorldSetups,
	runConditions = {},
}
