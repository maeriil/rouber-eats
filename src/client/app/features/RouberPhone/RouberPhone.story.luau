local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RouberPhone = require(script.Parent)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local mount = vide.mount

local function story()
	use_px.use_px()

	return {
		RouberPhone {},
	}
end

return function(target)
	return mount(story, target)
end
