local ReplicatedStorage = game:GetService("ReplicatedStorage")
local t = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local random = Random.new(os.clock())
local function pick_random_entity(basecomponents: { t.Entity }): t.Entity | nil
	local container = {}

	for i in world:query(unpack(basecomponents)):iter() do
		table.insert(container, i)
	end

	local idx = random:NextInteger(1, #container)

	if idx == 0 then
		return nil
	end

	return container[idx]
end

return pick_random_entity
