local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity

export type BaseBuildingType = {
	DoorMat: Entity,
	Door: Entity,
}

local store = {} :: { [Entity]: BaseBuildingType }

return store
