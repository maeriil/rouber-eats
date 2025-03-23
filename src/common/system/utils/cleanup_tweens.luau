local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local existing_tween_query = world:query(c.Tween):without(c.DoNotDelete):cached()
local function system()
	for i, tween in existing_tween_query:iter() do
		local tweenstatus = tween.PlaybackState
		if
			tweenstatus == Enum.PlaybackState.Cancelled or tweenstatus == Enum.PlaybackState.Completed
		then
			tween:Destroy()
			warn(`deleting the entity containing tween `)
			world:delete(i)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
