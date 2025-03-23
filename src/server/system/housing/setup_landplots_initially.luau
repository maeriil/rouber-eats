local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local planck = require(ReplicatedStorage.pkg.planck)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	local landplots = "LandPlot"
	local landplot_lists = CollectionService:GetTagged(landplots)

	for _, landplot in landplot_lists do
		assert(landplot:IsA("Model"), "Plot is expected to be a model holding three additional parts")

		local plot = landplot:FindFirstChild("BasePlot") :: Part?
		local doormat_location = landplot:FindFirstChild("DoorMatLocation") :: Part?
		local player_tp_location = landplot:FindFirstChild("PlayerTPLocation") :: Part?

		assert(plot, `Baseplot part does not exist for one of the land plots`)
		assert(doormat_location, `Doormat part does not exist for one of the land plots`)
		assert(player_tp_location, `Playertp part does not exist for one of the land plots`)

		local land = world:entity()
		world:add(land, c.LandPlot)
		world:set(land, c.Transform, plot.CFrame)
		world:set(land, c.Size, plot.Size :: never)
		world:add(land, c.Vacant)
		world:set(land, pairs.DoormatTransform, doormat_location.CFrame)
		world:set(land, pairs.PlayerExteriorTPTransform, player_tp_location.CFrame)

		-- Destroy at the end
		-- for _, basepart in landplot:GetChildren() do
		-- 	if not basepart:IsA("BasePart") then continue end
		-- 	basepart.Transparency = 1
		-- 	basepart.CanCollide = false
		-- 	basepart.Anchored = true
		-- end
		plot:Destroy()
	end

	print(`Completed setting up landplots to the world initially`)
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.ServerInitialize.BuildingSetup,
	runConditions = {
		planck.runOnce(),
	},
}
