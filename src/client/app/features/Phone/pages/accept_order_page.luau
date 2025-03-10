local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local create = vide.create
local px = use_px.px

local function accept_order_page(props)
	local order = next_order()
	return {
		padding {
			padding = function()
				return UDim.new(0, px(100))
			end,
		},
		vlayout {
			pad = function()
				return UDim.new(0, px(16))
			end,
		},
		create "TextLabel" {
			BackgroundColor3 = Color3.fromRGB(100, 255, 0),
			Size = function()
				return UDim2.new(1, 0, 0, px(80))
			end,
			Text = "Delivery",
			TextSize = function()
				return px(32)
			end,
			LayoutOrder = order(),
			TextXAlignment = Enum.TextXAlignment.Left,
		},
		frame {
			order = order(),
			size = function()
				return UDim2.new(1, 0, 0, px(80))
			end,
			hlayout {
				pad = function()
					return UDim.new(0, px(32))
				end,
			},
			create "TextLabel" {
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				Text = "Approx. Dist",
				TextSize = function()
					return px(32)
				end,
				LayoutOrder = order(),
			},
			create "TextLabel" {
				AutomaticSize = Enum.AutomaticSize.X,
				Size = UDim2.new(0, 0, 1, 0),
				Text = "1000 studs",
				TextSize = function()
					return px(32)
				end,
				LayoutOrder = order(),
			},
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
			},
			create "TextButton" {
				LayoutOrder = 1,
				Text = "Accept",
				TextSize = function()
					return px(32)
				end,
				Size = function()
					return UDim2.new(0, px(200), 1, 0)
				end,
				Activated = function() end,
				BackgroundColor3 = Color3.fromRGB(0, 255, 0),
				create "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill,
				},
			},
			create "TextButton" {
				LayoutOrder = 2,
				Text = "Decline",
				TextSize = function()
					return px(32)
				end,
				Size = function()
					return UDim2.new(0, px(200), 1, 0)
				end,
				Activated = function()
					print("NO PRESSED")
				end,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				create "UIFlexItem" {
					FlexMode = Enum.UIFlexMode.Fill,
				},
			},
		},
	}
end

return accept_order_page
