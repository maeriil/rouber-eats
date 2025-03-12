local ReplicatedStorage = game:GetService("ReplicatedStorage")
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount

local function story()
	use_px.use_px()

	return {}
end

return function(target)
	return mount(story, target)
end
