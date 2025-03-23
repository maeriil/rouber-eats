local ReplicatedStorage = game:GetService("ReplicatedStorage")
local planck = require(ReplicatedStorage.pkg.planck)

--[[
  The first pipeline to run
]]
export type ServerInitialize = {
	BuildingSetup: planck.Phase,
	MapSetup: planck.Phase,
}

local ServerInitialize = {} :: ServerInitialize
ServerInitialize.BuildingSetup = planck.Phase.new("BuildingSetup")
ServerInitialize.MapSetup = planck.Phase.new("MapSetup")

local ServerInitializePipeline = planck.Pipeline
	.new("ServerInitialize")
	:insert(ServerInitialize.BuildingSetup)
	:insert(ServerInitialize.MapSetup)

--[[
  The next pipeline to run is PlayerAdded and PlayerRemoved Pipeline. This is where we
  make the server handle all the requirements for player to be onboarded properly
]]

export type PlayerAddedRemoved = {
	Added: planck.Phase,
	Datastore: planck.Phase,
	WorldSetups: planck.Phase,
}

local PlayerAddedRemoved = {} :: PlayerAddedRemoved
PlayerAddedRemoved.Added = planck.Phase.new("Added")
PlayerAddedRemoved.Datastore = planck.Phase.new("Datastore")
PlayerAddedRemoved.WorldSetups = planck.Phase.new("WorldSetups")

local PlayerAddedRemovedPipeline = planck.Pipeline
	.new("PlayerAddedRemoved")
	:insert(PlayerAddedRemoved.Added)
	:insert(PlayerAddedRemoved.Datastore)
	:insert(PlayerAddedRemoved.WorldSetups)

--[[
  Once the player has setup properly, we need to work on general LandPlot and Housing updates
  The reason this comes immedaitely after is that we want to prioritizing setting up players houses
  before setting up others
]]
export type Housing = {
	HousingCleanup: planck.Phase,
	HousingOnPlayerAdded: planck.Phase,
	HousingUpdate: planck.Phase,
}

local Housing = {} :: Housing
Housing.HousingCleanup = planck.Phase.new("HousingCleanup")
Housing.HousingOnPlayerAdded = planck.Phase.new("HousingOnPlayerAdded")
Housing.HousingUpdate = planck.Phase.new("HousingUpdate")

local HousingPipeline = planck.Pipeline
	.new("Housing")
	:insert(Housing.HousingCleanup)
	:insert(Housing.HousingOnPlayerAdded)
	:insert(Housing.HousingUpdate)

return {
	_pipelines = {
		ServerInitializePipeline = ServerInitializePipeline,
		PlayerAddedRemovedPipeline = PlayerAddedRemovedPipeline,
		HousingPipeline = HousingPipeline,
	},
	ServerInitialize = ServerInitialize,
	PlayerAddedRemoved = PlayerAddedRemoved,
	Housing = Housing,
}
