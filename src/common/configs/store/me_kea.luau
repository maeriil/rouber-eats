local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

--[[
  TODO: what else would typically go on this file?
  Would we store store items here too? Do we need to in the question

]]
local store: types.StoreConfigType = {
	id = world:entity() :: types.Entity,
	string_id = script.Name,
	display_image = "",
	display_name = "MeKea",
}

return store
