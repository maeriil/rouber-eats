local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local previous = require(ReplicatedStorage.common.utility.previous)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local open_close = world
	:query(pair(c.Tween, c.Start), pair(c.Tween, c.End), c.OpenStatus, previous(c.OpenStatus))
	:with(c.Door)
	:without(c.CannotOpen)
	:cached()

local function system()
	for i, opentween, closetween, status, prevstatus in open_close:iter() do
		if status == prevstatus then
			continue
		end
		local should_open = status == "open"

		if should_open then
			opentween:Play()
		else
			closetween:Play()
		end

		world:set(i, previous(c.OpenStatus), status)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
