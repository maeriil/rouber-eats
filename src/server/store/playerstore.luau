local ReplicatedStorage = game:GetService("ReplicatedStorage")

local types = require(ReplicatedStorage.types)
type Entity = types.Entity

export type PlayerDetails = {}

local store: {
	[Player]: PlayerDetails,
} = {}

return store
