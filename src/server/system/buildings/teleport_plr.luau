-- When players come in touch with a door, they will fire to server
-- in server, if a player can enter the building, we will teleport them to the dest location

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local TP_COOLDOWN = pair(c.Lifetime, c.TeleportTo)
local teleport = world:query(c.Model, c.TeleportTo, c.PrimaryPart):without(TP_COOLDOWN):cached()
local function system()
	-- for i, model, cf in world:query(c.Model, c.TeleportTo):iter() do
	for i, model, cf, hrp in teleport:iter() do
		model:PivotTo(cf + Vector3.new(0, hrp.Size.Y / 2, 0))
		world:remove(i, c.TeleportTo)
		world:set(i, TP_COOLDOWN, 1)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
