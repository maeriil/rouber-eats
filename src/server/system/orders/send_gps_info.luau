local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planck = require(ReplicatedStorage.pkg.planck)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ChildOf = jecs.ChildOf
local pair = jecs.pair
local __ = jecs.Wildcard

local function send_restaurant_direction() end

local function send_residence_direction() end

local function system() end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
