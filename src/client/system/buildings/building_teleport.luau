local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local cast_query = world:query(c.CastStatus):with(c.TeleportZone):without(pairs.TPCooldown):cached()

local function system()
	for i, is_player_on_part in cast_query:iter() do
		local parent = world:parent(i) :: t.Entity
		local parentbuilding = world:get(parent, c.Model)
		assert(parentbuilding, `Parent building must exist at runtime`)

		if not is_player_on_part then
			continue
		end

		events.IWantToTeleportInOrOut:send(parentbuilding)
		world:set(i, c.CastStatus, false)
		world:set(i, pairs.TPCooldown, 1)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Phases.SteppedPhases.WorldCast,
	runConditions = {},
}
