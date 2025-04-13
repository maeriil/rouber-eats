local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local world = require(script.Parent.world)

local function target(entity: types.Entity | types.Id, relationship: types.Entity | types.Id)
	local index = 0

	--[[
    TODO: Idk if we should be returning Entity or Id
  ]]
	return function(): (number, types.Id)
		local target = world:target(entity, relationship, index)
		index += 1

		if target ~= nil then
			return index, target
		end

		return
	end
end

return target
