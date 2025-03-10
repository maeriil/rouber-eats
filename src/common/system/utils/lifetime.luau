local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local scheduler = require(ReplicatedStorage.common.ecs.scheduler)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	local dt = scheduler:getDeltaTime()
	for id, lifetime in world:query(c.Lifetime):iter() do
		local data = lifetime - dt
		if data <= 0 then
			world:remove(id, c.Lifetime)
		else
			world:set(id, c.Lifetime, data)
		end
	end

	for id in world:each(pair(c.Lifetime, __)) do
		local n = 0
		local wild = world:target(id, c.Lifetime, n)

		while wild ~= nil do
			local data = world:get(id, pair(c.Lifetime, wild)) :: number
			data -= dt

			if data <= 0 then
				world:remove(id, pair(c.Lifetime, wild))
				world:remove(id, wild)
			else
				world:set(id, pair(c.Lifetime, wild), data)
			end

			n = n + 1
			wild = world:target(id, c.Lifetime, n)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
