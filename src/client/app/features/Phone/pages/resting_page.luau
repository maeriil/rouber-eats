local ReplicatedStorage = game:GetService("ReplicatedStorage")
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local create = vide.create
local px = use_px.px

local function resting_page(props: {
	accept: () -> (),
	reject: () -> (),
})
	local order = next_order()
	return {
		padding {
			padding = function()
				return UDim.new(0, px(16))
			end,
		},
		vlayout {
			vflex = Enum.UIFlexAlignment.SpaceEvenly,
		},
		create "TextLabel" {
			Text = "You are currently on break. Do you want to work?",
			TextSize = function()
				return px(48)
			end,
			TextWrapped = true,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = function()
				return UDim2.new(1, 0, 0, 0)
			end,
			LayoutOrder = order(),
		},
		pane {
			size = function()
				return UDim2.new(1, 0, 0, px(96))
			end,
			order = order(),
			hlayout {
				pad = function()
					return UDim.new(0, px(16))
				end,
				hflex = Enum.UIFlexAlignment.SpaceAround,
			},
			create "TextButton" {
				LayoutOrder = 1,
				Text = "YES",
				TextSize = function()
					return px(22)
				end,
				Size = function()
					return UDim2.new(0, px(200), 1, 0)
				end,
				Activated = function()
					props.accept()
				end,
				BackgroundColor3 = Color3.fromRGB(0, 255, 0),
			},
			create "TextButton" {
				LayoutOrder = 1,
				Text = "NO",
				TextSize = function()
					return px(22)
				end,
				Size = function()
					return UDim2.new(0, px(200), 1, 0)
				end,
				Activated = function()
					props.reject()
				end,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			},
		},
	}
end

return resting_page
