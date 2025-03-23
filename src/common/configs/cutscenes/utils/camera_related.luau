local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local world = require(ReplicatedStorage.common.ecs.world)

local function tween_camera(position: vector, params: TweenInfo)
	local props = world:get(c.Camera, c.CameraProperties)
	assert(props ~= nil, "props must exist ")

	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Scriptable,
		fov = props.fov,
	})

	local id = world:entity()
	local goal = CFrame.new(position :: never)
	world:add(id, pairs.childof(c.Camera))
	world:set(id, c.TweenParams, params)
	world:set(id, pairs.EndTransform, goal)

	return id
end

return {
	tween_camera = tween_camera,
}
