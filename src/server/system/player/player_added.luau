local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local player_added = {}
Players.PlayerAdded:Connect(function(player: Player)
	table.insert(player_added, player)
end)
local function setup_client()
	for i = #player_added, 1, -1 do
		local player = player_added[i]

		local e = ref(player)
		world:set(e, c.Client, player)

		print(`Player {player.Name} has joined the game`)

		player_added[i] = nil
	end
end

local without_char = world:query(c.Client):without(c.Model):cached()
local function setup_character()
	for i, player in without_char:iter() do
		local char = player.Character
		if char == nil or char.Parent == nil or char.PrimaryPart == nil then
			continue
		end

		char.Archivable = true
		world:set(i, c.Model, char)
		world:set(i, c.PrimaryPart, char.PrimaryPart)
	end
end

local function system()
	setup_client()
	setup_character()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.Added,
	runConditions = {},
}
