local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
--[[
  Parts map is meant to be some useful part mapped to its parent entity
  For instance, this hashmap contains Door related parts, such as DoorCollide, or
  TeleportCollide, mapped to the exterior buildings entity.

  This removes the need of performing the expensive :FindFirstAncestorOfClass calls inside
  our important loops such as spatial queries
]]

local store = {} :: { [BasePart]: types.Entity }

return store
