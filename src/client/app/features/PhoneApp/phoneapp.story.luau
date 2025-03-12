local ReplicatedStorage = game:GetService("ReplicatedStorage")
local phonebase = require(script.Parent.phonebase)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local function story()
	use_px.use_px()

	return phonebase {}
end

return function(target)
	return vide.mount(story, target)
end
