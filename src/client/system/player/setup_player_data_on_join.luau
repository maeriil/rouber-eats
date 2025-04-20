-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local tr = require(ReplicatedStorage.common.ecs.target)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard
-- stylua: ignore end

--[[
  The server will initially send details about all the things the player owns to client world
  initially. We should set them up now
]]
local function system()
	local roubins = world:get(c.Client, c.Roubins)
	if roubins == nil then
		world:set(c.Client, c.Roubins, 0)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
