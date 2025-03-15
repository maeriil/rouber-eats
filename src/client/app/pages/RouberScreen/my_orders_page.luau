local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DashboardContent =
	require(ReplicatedStorage.client.app.features.RouberDashboard.DashboardContent)
local OrderPanelView = require(ReplicatedStorage.client.app.features.RouberDashboard.OrderPanelView)
local RouberOrderCard = require(ReplicatedStorage.client.app.features.Card.RouberOrderCard)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local px = use_px.px
local source = vide.source
local values = vide.values

local fallback: types.DeliveryOrderType = {
	clientid = -1 :: never,
	deliverytype = "",
	distance = -1,
	restaurant = {
		img = "",
		location = "",
		name = "No Item Selected",
	},
	reward = -1,
}

local function my_orders(props: {
	original_canvas_size: Vector2,
})
	local orderlist = uistore.DeliveryOrderList
	local selected = source(fallback) :: types.Source<types.DeliveryOrderType>
	local has_selected = source(false)

	return DashboardContent {
		original_canvas_size = props.original_canvas_size,
		panelcontent = {

			OrderPanelView {
				acceptclick = function()
					print(`Accepting the order of {selected().clientid}`)
				end,
				details = selected,
				showaccept = has_selected,
			},
		},
		content = {
			pane {
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				padding {
					padding = padding_types.px16,
				},
				vlayout {
					pad = padding_types.px16,
				},

				values(orderlist, function(content: types.DeliveryOrderType, a1: () -> number)
					return RouberOrderCard {
						height = function()
							return px(128)
						end,
						click = function()
							selected(content)
							has_selected(true)
						end,
						order = a1(),
						content = content,
					}
				end),
			},

			frame {
				size = function()
					return UDim2.new(1, 0, 0, px(128))
				end,
				pos = UDim2.new(0, 0, 1, 0),
				anchor = Vector2.new(0, 1),
				color = Color3.fromRGB(50, 50, 50),
			},
		},
	}
end

return my_orders
