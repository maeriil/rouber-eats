local ReplicatedStorage = game:GetService("ReplicatedStorage")

local components = require(ReplicatedStorage.common.ecs.components)
local world = require(ReplicatedStorage.common.ecs.world)
local types = require(ReplicatedStorage.types)

local function create_ui_event(t: types.Entity)
	local e = world:entity()
	world:add(e, components.UI_EVENT)
	world:add(e, t)

	return e
end

return create_ui_event
