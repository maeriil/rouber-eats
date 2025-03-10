local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local create = vide.create
local px = use_px.px

type props = {
	exit: () -> (),
	[number]: any,
}

local function phone(props)
	local layout = next_order()

	return frame {
		size = function()
			return UDim2.new(0, px(600), 0, px(600))
		end,
		pos = UDim2.new(0.5, 0, 0.5, 0),
		anchor = Vector2.new(0.5, 0.5),
		vlayout {},
		pane {
			name = "Header",
			size = function()
				return UDim2.new(1, 0, 0, px(60))
			end,
			order = layout(),

			create "TextButton" {
				Size = function()
					return UDim2.new(0, px(150), 0, px(60))
				end,
				Text = "EXIT",
				TextSize = function()
					return px(text_sizes.heading.h2)
				end,
				BackgroundColor3 = Color3.fromRGB(255, 0, 0),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Activated = function()
					props.exit()
				end,
			},
		},
		frame {
			name = "content",
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			order = layout(),
			create "UIFlexItem" {
				FlexMode = Enum.UIFlexMode.Fill,
			},
			color = Color3.fromRGB(100, 100, 100),
			unpack(props),
		},
		pane {
			name = "footer",
			size = function()
				return UDim2.new(1, 0, 0, px(60))
			end,
			order = layout(),
		},
	}
end

return phone
