local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local iconactive = require(script.Parent.iconactive)
local padding = require(ReplicatedStorage.client.app.components.padding)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount
local px = use_px.px

local function story()
	use_px.use_px()

	return frame {
		size = UDim2.new(1, 0, 0, px(200)),
		anchor = Vector2.new(0, 0.5),
		pos = UDim2.new(0, 0, 0.5, 0),
		vlayout {},
		padding {
			padding = function()
				return UDim.new(0, px(16))
			end,
		},
		frame {
			size = UDim2.new(1, 0, 1, 0),
			iconactive {
				square {},
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
