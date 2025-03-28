local ReplicatedStorage = game:GetService("ReplicatedStorage")
local planck = require(ReplicatedStorage.pkg.planck)

--[[
  Server related phases. Refer to the figma diagram to know how exactly the phases are ordered
]]
export type ServerInitialize = {
	DataSetup: planck.Phase,
	BuildingSetup: planck.Phase,
	MapSetup: planck.Phase,
}
local ServerInitialize = {} :: ServerInitialize
ServerInitialize.DataSetup = planck.Phase.new("DataSetup")
ServerInitialize.BuildingSetup = planck.Phase.new("BuildingSetup")
ServerInitialize.MapSetup = planck.Phase.new("MapSetup")

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

--[[
After this, we refer to our generic Update pipeline
]]

--[[
  Client related Phases. Refer to the figma diagram to know how exactly the phases are ordered
]]
export type GeneralSetupsPipeline = {
	Cleanup: planck.Phase,
	Setup: planck.Phase,
}
local GeneralSetupsPipeline = {} :: GeneralSetupsPipeline
GeneralSetupsPipeline.Setup = planck.Phase.new("Setup")
GeneralSetupsPipeline.Cleanup = planck.Phase.new("Cleanup")

--[[
  These are the phases that we would typically use for both server and client so theres no need
  to differentiate them much
]]
local PreUpdate = planck.Phase.new("PreUpdate")
local Update = planck.Phase.new("Update")
local PostUpdate = planck.Phase.new("PostUpdate")

local NetStart = planck.Phase.new("NetStart")
local NetEnd = planck.Phase.new("NetEnd")

local First = planck.Phase.new("First")
local Last = planck.Phase.new("Last")

return {
	Client = {
		GeneralSetups = GeneralSetupsPipeline,
		_pipelines = {
			GeneralSetupsPipeline = planck.Pipeline
				.new("GeneralSetups")
				:insert(GeneralSetupsPipeline.Cleanup)
				:insert(GeneralSetupsPipeline.Setup),
		},
	},
	Server = {
		ServerInitialize = ServerInitialize,
		PlayerAddedRemoved = PlayerAddedRemoved,
		Housing = Housing,
		_pipelines = {
			ServerInitializePipeline = planck.Pipeline
				.new("ServerInitialize")
				:insert(ServerInitialize.DataSetup)
				:insert(ServerInitialize.BuildingSetup)
				:insert(ServerInitialize.MapSetup),
			PlayerAddedRemoved = planck.Pipeline
				.new("PlayerAddedRemoved")
				:insert(PlayerAddedRemoved.Added)
				:insert(PlayerAddedRemoved.Datastore)
				:insert(PlayerAddedRemoved.WorldSetups),
			HousingPipeline = planck.Pipeline
				.new("Housing")
				:insert(Housing.HousingCleanup)
				:insert(Housing.HousingOnPlayerAdded)
				:insert(Housing.HousingUpdate),
		},
	},

	PreUpdate = PreUpdate,
	Update = Update,
	PostUpdate = PostUpdate,

	NetStart = NetStart,
	NetEnd = NetEnd,

	First = First,
	Last = Last,
}
