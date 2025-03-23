local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	local it = world:query(c.Dialogue):iter()
	local e, dialogue = it()
	if not e then
		return
	end

	-- continue with our dialogue now
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
