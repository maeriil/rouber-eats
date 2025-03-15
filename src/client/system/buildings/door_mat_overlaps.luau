local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	-- for i, doormat, params in world:query(c.DoorMat, c.OverParams):iter() do
	-- local hits = workspace:GetPartsInPart(doormat, params)
	-- local status = "close"

	-- for i, basepart in hits do
	-- 	local model = basepart:FindFirstAncestorOfClass("Model")
	-- 	if not model then
	-- 		continue
	-- 	end
	-- 	if Players:GetPlayerFromCharacter(model) then
	-- 		status = "open"
	-- 	end
	-- end

	-- world:set(i, c.OpenStatus, status)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
