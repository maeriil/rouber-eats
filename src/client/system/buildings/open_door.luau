local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local previous = require(ReplicatedStorage.common.utility.previous)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local pre = previous(c.OpenStatus)

local open_door = world:query(c.PrimaryPart):with(c.Door, c.OpenStatus):without(pre):cached()
local close_door = world:query(c.PrimaryPart):with(c.Door, pre):without(c.OpenStatus):cached()

local function system() end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
