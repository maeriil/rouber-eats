local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local function for_each_target(entity: t.Entity, target: t.Entity, callback: (id: t.Entity) -> ())
	local n = 0
	local current = world:target(entity, target, n)

	while current ~= nil do
		callback(current)

		n += 1
		current = world:target(entity, target, n)
	end
end

return for_each_target
