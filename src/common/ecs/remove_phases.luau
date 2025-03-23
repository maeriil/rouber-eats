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

export type ServerResponsePhases = {
	DeleteHouseOwner: planck.Phase,
	SetupOwnerIdOnClient: planck.Phase,
	SetupHouseOnClient: planck.Phase,
	SetupAnyOrder: planck.Phase,
}
local ServerResponsePhases = {} :: ServerResponsePhases

ServerResponsePhases.DeleteHouseOwner = planck.Phase.new("DeleteHouseOwner")
ServerResponsePhases.SetupOwnerIdOnClient = planck.Phase.new("SetupOwnerIdOnClient")
ServerResponsePhases.SetupHouseOnClient = planck.Phase.new("SetupHouseOnClient")
ServerResponsePhases.SetupAnyOrder = planck.Phase.new("SetupAnyOrder")

local ServerResponsePipeline = planck.Pipeline
	.new("ServerToClientEvent")
	:insert(ServerResponsePhases.SetupOwnerIdOnClient)
	:insert(ServerResponsePhases.SetupHouseOnClient)
	:insert(ServerResponsePhases.SetupAnyOrder)
	:insert(ServerResponsePhases.DeleteHouseOwner)

--[[
	We need to run our server in proper order basically
	ServerInitialize will be the first one. Here, anything related to server init will run
		This should include things like setting up restaurants, setting up landplots, and
		moving map to server storage
	AllocateVacantSlots will be the second one. This is primarily used to allocate a vacant lot
		to a NPC


	]]
export type ServerUpdatePhases = {}

return {
	Pipelines = {
		SteppedPipeline = SteppedPipeline,
		ServerResponsePipeline = ServerResponsePipeline,
	},
	Phases = {
		SteppedPhases = SteppedPhases,
		ServerResponsePhases = ServerResponsePhases,
	},
}
