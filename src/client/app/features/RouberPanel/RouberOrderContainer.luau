local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RouberOrderCard = require(script.Parent.RouberOrderCard)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local px = use_px.px
local indexes = vide.indexes
local create = vide.create

type props = {
	orders: types.Source<{ [string]: types.DeliveryOrderType }>,
	active_order: types.Source<string>,
}

local function RouberOrderScrollingFrame(props: props)
	local order = next_order()
	return {
		hlayout {
			valign = Enum.VerticalAlignment.Bottom,
			pad = padding_types.px48,
		},

		pane {
			size = function()
				return UDim2.new(0, px(36), 0.4, 0)
			end,
			order = order(),

			frame {
				size = UDim2.new(1, 0, 1, 0),
				color = Color3.fromRGB(255, 0, 0),
				rotation = -4,
				anchor = Vector2.new(0.5, 1),
				pos = UDim2.new(0.5, 0, 1, 0),
			},
		},

		create "ScrollingFrame" {
			BackgroundColor3 = Color3.fromRGB(0, 0, 255),
			Size = UDim2.new(1, 0, 1, 0),
			LayoutOrder = order(),
			flexfill {},
			vlayout {
				pad = padding_types.px32,
			},
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,

			indexes(props.orders, function(_content: () -> types.DeliveryOrderType, key: string)
				local content = _content()
				return RouberOrderCard {
					content = function()
						return content
					end,
					active = function()
						local curr_active_key = props.active_order()
						local my_key = key
						return curr_active_key == my_key
						-- return false
					end,
					click = function()
						local my_key = key
						props.active_order(my_key)
					end,
				}
			end),
		},
	} :: { any }
end

return RouberOrderScrollingFrame
