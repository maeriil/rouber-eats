local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local player_removed = {}
Players.PlayerRemoving:Connect(function(player: Player)
	table.insert(player_removed, player)
end)

local function player_removing()
	for i = #player_removed, 1, -1 do
		local player = player_removed[i]
		local id, cleanup = ref(player)

		task.defer(function()
			-- Once everything is verified to be completed, we should delete the entity
			-- We should probably defer the deleting stuff to the end
			local residence_id = world:exists_get(id, c.Residence)
			world:add(residence_id, c.Cleanup)

			world:remove(id, c.Client)
			cleanup()
		end)

		player_removed[i] = nil
	end
end

local function system()
	player_removing()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.Added,
	runConditions = {},
}
