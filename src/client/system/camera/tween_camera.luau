local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local tween_camera_query = world
	:query(c.TweenParams, pairs.EndTransform)
	:with(pairs.childof(c.Camera), c.StartAnimation)
	:without(c.Tween)
	:cached()

local function system()
	for i, params, goal in tween_camera_query:iter() do
		local camera = workspace.CurrentCamera
		local tween = TweenService:Create(camera, params, {
			CFrame = goal,
		})

		world:set(i, c.Tween, tween)
		world:remove(i, c.StartAnimation)
		world:remove(i, pairs.EndTransform)

		tween:Play()
	end
end

return {
	name = script.Name,
	system = system,
	-- Currently at incorrect phase...
	phase = phases.First,
	runConditions = {},
}
