local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local buildings = require(ReplicatedStorage.common.store.buildings)
local planck = require(ReplicatedStorage.pkg.planck)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for e, v in buildings do
		local doormat, params = world:get(v.DoorMat, c.DoorMat, c.OverParams)
		local results = workspace:GetPartsInPart(doormat, params)
		local status = "close"

		for _, part in results do
			local ancestor = part:FindFirstAncestorOfClass("Model")
			local player = Players:GetPlayerFromCharacter(ancestor)
			if player ~= Players.LocalPlayer then
				continue
			end

			status = "open"
			break
		end

		world:set(v.Door, c.OpenStatus, status)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {
		planck.runOnce(),
	},
}
