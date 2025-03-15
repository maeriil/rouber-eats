local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local for_each_target = require(ReplicatedStorage.common.utility.for_each_target)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local previous = require(ReplicatedStorage.common.utility.previous)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local cast_query = world:query(c.CastStatus, c.BasePart, c.OverParams):with(c.DoormatZone):cached()
local door_query = world:query(c.DoorStatus, previous(c.DoorStatus)):without(c.CannotOpen):cached()
local doortween_query =
	world:query(pairs.TweenStart, pairs.TweenEnd, c.DoorStatus, c.TweenStatus):with(c.Door):cached()

local function system()
	for i, is_player_on_part, part, params in cast_query:iter() do
		local parent = world:parent(i) :: t.Entity
		local is_door_open = world:get(parent, c.DoorStatus)
		if is_door_open == nil then
			warn(`Parent must contain door status. This is likely a bug`)
			world:set(i, c.CastStatus, false)
			continue
		end

		-- If the door was open, close it
		if not is_player_on_part and is_door_open then
			world:set(parent, c.DoorStatus, false)
			world:set(i, c.CastStatus, false)
			continue
		end

		-- If a player doesnt have access to house, then CannotOpen exists in our building
		-- so if it has it, dont continue to
		if world:has(parent, c.CannotOpen) then
			world:set(i, c.CastStatus, false)
			continue
		end

		if is_player_on_part and not is_door_open then
			world:set(parent, c.DoorStatus, true)
		end
		world:set(i, c.CastStatus, false)
	end

	for i, doorstatus, prev_doorstatus in door_query:iter() do
		if doorstatus == prev_doorstatus then
			continue
		end

		for_each_target(i, c.Door, function(target)
			world:set(target, c.DoorStatus, doorstatus)
			world:set(target, c.TweenStatus, true)
		end)

		world:set(i, previous(c.DoorStatus), doorstatus)
	end

	for i, starttween, endtween, doorstatus, tweenstatus in doortween_query:iter() do
		if not tweenstatus then
			continue
		end

		if doorstatus then
			starttween:Play()
		else
			endtween:Play()
		end

		world:set(i, c.TweenStatus, false)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Phases.SteppedPhases.WorldCast,
	runConditions = {},
}
