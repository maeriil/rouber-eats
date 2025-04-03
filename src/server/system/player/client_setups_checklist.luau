local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  Move all the i_have_completed whatever events to here
  I honestly hate how i need to double define remotes so im considering just using a
  regular remotes here
]]

local function system() end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
