-- stylua: ignore start
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs              = require(ReplicatedStorage.pkg.jecs)

local c                 = require(ReplicatedStorage.common.ecs.components)
local p                 = require(ReplicatedStorage.common.ecs.pairs)
local phases            = require(ReplicatedStorage.common.ecs.phases)
local planck            = require(ReplicatedStorage.pkg.planck)
local world             = require(ReplicatedStorage.common.ecs.world)
local __                = jecs.Wildcard
-- stylua: ignore end

local function system()
	local landplots = "LandPlot"
	local landplot_lists = CollectionService:GetTagged(landplots)

	for _, landplot in landplot_lists do
		assert(landplot:IsA("Model"), "Plot is expected to be a model holding three additional parts")

		local plot = landplot:FindFirstChild("BasePlot") :: Part?
		local doormat_location = landplot:FindFirstChild("DoorMatLocation") :: Part?
		local player_tp_location = landplot:FindFirstChild("PlayerTPLocation") :: Part?

		assert(plot, "Baseplot part does not exist for one of the land plots")
		assert(doormat_location, "Doormat part does not exist for one of the land plots")
		assert(player_tp_location, "Playertp part does not exist for one of the land plots")

		local land = world:entity()
		world:set(land, c.Transform, plot.CFrame)
		world:set(land, p.Transform(c.DoormatZone), doormat_location.CFrame)
		world:set(land, p.Transform(c.TeleportZone), player_tp_location.CFrame)
		world:add(land, c.LandPlot)
		world:add(land, c.Vacant)

		plot:Destroy()
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.ServerInitialize.BuildingSetup,
	runConditions = {
		planck.runOnce(),
	},
}
