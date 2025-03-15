local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)

return function<T>(entity: t.Entity)
	return jecs.pair(jecs.ChildOf, entity)
end
