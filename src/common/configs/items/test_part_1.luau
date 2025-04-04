local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

--[[
  TODO: what else would typically go on this file?
  Would we store store items here too? Do we need to in the question

]]
local item: types.ItemConfigType = {
	id = world:entity() :: types.Entity,
	string_id = script.Name,
	display_name = `Testing Part`,
	base_price = 5,
	rarity = 0.0,
}

return item
