local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local phone = require(script.Parent)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local px = use_px.px
local setup_px = use_px.use_px

local function story()
	setup_px()

	return frame {
		size = UDim2.fromScale(1, 1),
		color = Color3.fromRGB(100, 100, 100),
		phone {},
	}
end

return function(target)
	return vide.mount(story, target)
end
