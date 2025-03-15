local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RouberDashboard = require(ReplicatedStorage.client.app.features.RouberDashboard)
local my_orders_page = require(script.my_orders_page)
local my_profile_page = require(script.my_profile_page)
local orders_page = require(script.orders_page)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local source = vide.source
local switch = vide.switch
local px = use_px.px

local function RouberScreen(props)
	local activepage =
		source("Orders" :: types.RouberScreenPages) :: types.Source<types.RouberScreenPages>

	local orders_page_name: types.RouberScreenPages = "Orders"
	local my_orders_page_name: types.RouberScreenPages = "My Orders"
	local my_profile_page_name: types.RouberScreenPages = "My Profile"
	local original_canvas_size = Vector2.new(1280, 720)

	return pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,

		RouberDashboard {
			original_canvas_size = original_canvas_size,
			switch(activepage) {
				[orders_page_name] = function()
					return my_orders_page {
						original_canvas_size = original_canvas_size,
					}
				end,
				--[[ 				[my_orders_page_name] = function()
					return orders_page {
						original_canvas_size = original_canvas_size,
					}
				end,
				[my_profile_page_name] = function()
					return my_profile_page {
						original_canvas_size = original_canvas_size,
					}
				end, ]]
			},
		},
	}
end

return RouberScreen
