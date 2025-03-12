local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local player_added = {}
Players.PlayerAdded:Connect(function(player: Player)
	table.insert(player_added, player)
end)

local function not_setup_player()
	for _, player in Players:GetPlayers() do
		if playerdatastore[player] ~= nil and playerstore[player] == nil then
			-- This means the data store has loaded but playerstore is not set up
			-- setup the player store

			playerstore[player] = {
				has_setup_restaurant = false,
				has_setup_apartments = false,
				has_setup_house = false,
				sent_req_to_setup_apartments = false,
				sent_req_to_setup_house = false,
				sent_req_to_setup_restaurant = false,
				residence = (1 :: unknown) :: Entity,
				unlocked_house = false,
				unlocked_mansion = false,
				has_sent_existing_world_order = false,
				active_orders = {},
			}
		end
	end
end

local without_char = world:query(c.Client):without(c.Model):cached()
local function add_character()
	for i, player in without_char:iter() do
		local char = player.Character
		if not char or not char.PrimaryPart then
			continue
		end
		world:set(i, c.Model, char)
		world:set(i, c.PrimaryPart, char.PrimaryPart)
	end
end

local function system()
	for i = #player_added, 1, -1 do
		local player = player_added[i]
		local e = ref(player)
		world:set(e, c.Client, player)

		task.spawn(function()
			-- Initally, we need to halt any operation until the data store has succeded
			if RunService:IsStudio() then
				task.wait(1)
				-- In studio, it could be the case that player spawns before server. This is why
				-- lets delay it by 1 second.
			end
			local success = true
			if success then
				-- The below details must come from data store
				playerdatastore[player] = {
					coins = 0,
					gems = 0,
				}
			end
		end)

		player_added[i] = nil
	end

	not_setup_player()
	add_character()
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.First,
	runConditions = {},
}
