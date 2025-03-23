local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planck = require(ReplicatedStorage.pkg.planck)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local __ = jecs.Wildcard

local function send_restaurant_direction() end

local function send_residence_direction() end

local function system() end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
