local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local cleanup = vide.cleanup

return function<T>(event: RBXScriptSignal<T>, callback: (T) -> ())
	local connection = event:Connect(callback)

	cleanup(connection)

	return connection
end
