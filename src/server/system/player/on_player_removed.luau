local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair
local __ = jecs.Wildcard

local player_removed = {}
Players.PlayerRemoving:Connect(function(player: Player)
	table.insert(player_removed, player)
end)

local function system()
	for i = #player_removed, 1, -1 do
		local player = player_removed[i]
		local _e, cleanup = ref(player)

		task.defer(function()
			-- Once everything is verified to be completed, we should delete the entity
			-- We should probably defer the deleting stuff to the end
			cleanup()
			playerstore[player] = nil
		end)

		player_removed[i] = nil
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.First,
	runConditions = {},
}
