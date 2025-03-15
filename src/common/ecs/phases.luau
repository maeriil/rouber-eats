local ReplicatedStorage = game:GetService("ReplicatedStorage")
local planck = require(ReplicatedStorage.pkg.planck)

export type SteppedPhases = {
	PlayerCast: planck.Phase,
	WorldCast: planck.Phase,
	Reconcile: planck.Phase,
}
local SteppedPhases = {} :: SteppedPhases

SteppedPhases.PlayerCast = planck.Phase.new("PlayerCast")
SteppedPhases.WorldCast = planck.Phase.new("WorldCast")
SteppedPhases.Reconcile = planck.Phase.new("Reconcile")

local SteppedPipeline = planck.Pipeline
	.new("RaycastPipeline")
	:insert(SteppedPhases.PlayerCast)
	:insert(SteppedPhases.WorldCast)
	:insert(SteppedPhases.Reconcile)

return {
	Pipelines = {
		SteppedPipeline = SteppedPipeline,
	},
	Phases = {
		SteppedPhases = SteppedPhases,
	},
}
