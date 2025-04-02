local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local planck = require(ReplicatedStorage.pkg.planck)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
	Something to keep in back of our mind is that what if our other systems don't finish
	putting them to the ecs world? Can that even happen?

	Honestly im not sure, might be dumb question but worth asking around....
]]

local function system()
	local map = workspace.map :: Folder?
	assert(map ~= nil, "Map root folder must exist at runtime")

	-- Unparent from workspace and store it in server storage.
	-- We will store a reference to it in our ecs world

	map.Parent = ServerStorage
	world:set(c.Map, c.Map, map)
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.ServerInitialize.MapSetup,
	runConditions = {
		planck.runOnce(),
	},
}
