local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local change_mode = world:query(c.CameraProperties):cached()
local function system()
	local currentcamera = workspace.CurrentCamera
	for i, config in change_mode:iter() do
		local type = config.type
		if currentcamera.CameraType ~= type then
			currentcamera.CameraType = type
		end

		if currentcamera.FieldOfView ~= config.fov then
			currentcamera.FieldOfView = config.fov
		end
	end
end

return {
	name = script.Name,
	system = system,
	-- Currently at incorrect phase...
	phase = phases.First,
	runConditions = {},
}
