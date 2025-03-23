local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local planck = require(ReplicatedStorage.pkg.planck)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local every = 500
local function system()
	-- warn(`Cleaning up world. Ensure that nothing is breaking`)
	-- warn(
	-- 	`If something is breaking, then 99% of time, we are doing something we shouldn't be. File an issue`
	-- )
	world:cleanup()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = { planck.timePassed(every) },
}
