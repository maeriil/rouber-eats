local ReplicatedStorage = game:GetService("ReplicatedStorage")
local effect1 = require(script.Parent.effect1)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount
local px = use_px.px

local function story()
	local order = next_order()

	return frame {
		color = Color3.fromRGB(),
		size = UDim2.new(0.8, 0, 1, 0),
		vlayout {},
		padding {
			padding = padding_types.px48,
		},
		pane {
			size = UDim2.new(0.8, 0, 0, px(128)),
			order = order(),
			effect1 {},
		},
	}
end

return function(target)
	return mount(story, target)
end
