local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

return function<T>(component: jecs.Id<T>)
	return jecs.pair(component, jecs.Rest)
end
