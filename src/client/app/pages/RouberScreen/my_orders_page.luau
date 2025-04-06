local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DashboardContent =
	require(ReplicatedStorage.client.app.features.RouberDashboard.DashboardContent)
local Mock_Delivery_list =
	require(ReplicatedStorage.client.app.pages.RouberScreen._MOCKS.Mock_Delivery_list)
local OrderPanelView = require(ReplicatedStorage.client.app.features.RouberDashboard.OrderPanelView)
local RouberOrderContainer =
	require(ReplicatedStorage.client.app.features.RouberPanel.RouberOrderContainer)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local source = vide.source
local px = use_px.px

local function my_orders(props: {
	original_canvas_size: Vector2,
})
	local orderlist = uistore.DeliveryOrderList
	local selected = source("")
	-- local has_selected = source(false)

	return DashboardContent {
		original_canvas_size = props.original_canvas_size,
		panelcontent = {
			OrderPanelView {
				acceptclick = function()
					local selected_key = selected()
					print(`Accepting the order of key = {selected()}`)
					local orders_list = orderlist()
					local details = orders_list[selected_key]
					-- warn(`dispatching the order id to event queue...`)
					eventqueue.dispatch_order_accept(details.order_id)
					selected("")
				end,
				details = function()
					local content = orderlist()[selected()]
					if content == nil then
						return Mock_Delivery_list["one"]
					end
					return content
				end,
				showaccept = function()
					return selected() ~= ""
				end,
			},
		},
		content = {
			vlayout {},
			frame {
				color = Color3.fromRGB(255, 255, 0),
				size = function()
					return UDim2.new(1, 0, 0, px(64))
				end,
			} :: never,
			pane {
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				flexfill {},
				RouberOrderContainer {
					orders = orderlist,
					active_order = selected,
				},
			} :: never,
		} :: never,
	}
end

return my_orders
