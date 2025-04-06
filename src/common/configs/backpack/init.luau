local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
--[[
  Backpack can have different sizes and tiers. I haven't decided if they would mostlyl
  be paid or unlockables but they shold exist

  They can just be an array tbh?

  1 = Basic kind
  2 = One tier better kind?
]]

-- Basic Backpack kind
local basic_backpack_kind: types.BackpackEnumConfigType = {
	furnishing = 100,
	items = 100,
}

-- higher tier backpack kind
local backpack_kind_tier_1: types.BackpackEnumConfigType = {
	furnishing = 200,
	items = 200,
}

local backpack_kinds = {
	basic_backpack_kind,
	backpack_kind_tier_1,
} :: types.Array<types.BackpackEnumConfigType>

return backpack_kinds
