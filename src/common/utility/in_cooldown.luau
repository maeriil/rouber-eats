local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local pair = jecs.pair

local function is_in_cooldown(entity: types.Entity, component: types.Entity<unknown>)
	return world:has(entity, pair(components.Lifetime, component))
end

local function in_interaction_cooldown(entity: types.Entity)
	return is_in_cooldown(entity, components.Interacted)
end

return {
	in_cooldown = is_in_cooldown,
	in_interaction_cooldown = in_interaction_cooldown,
}
