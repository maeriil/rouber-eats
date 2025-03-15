local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)

return function<T>(component: types.Entity<T>)
	return jecs.pair(components.Cooldown, component)
end
