local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local planck = require(ReplicatedStorage.pkg.planck)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Custom,
		fov = 70,
	})
end

return {
	name = script.Name,
	system = system,
	-- Currently at incorrect phase...
	phase = phases.First,
	runConditions = { planck.runOnce() },
}
