local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local interval = require(ReplicatedStorage.common.ecs.interval)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planck_run = require(ReplicatedStorage.pkg.planckrunservice)
local scheduler = require(ReplicatedStorage.common.ecs.scheduler)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

local every = interval(3)
local function system()
	if every() then
		local x = world:entity()
		world:set(x, pair(components.Lifetime, components.Claim), 1)
		world:set(x, pair(components.Lifetime, components.Assign), 2)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planck_run.Phases.Update,
	runConditions = {},
}
