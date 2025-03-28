local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DashboardContent = require(script.Parent.DashboardContent)
local RouberDashboard = require(script.Parent)
local RouberOrderCard = require(ReplicatedStorage.client.app.features.Card.RouberOrderCard)
local assets = require(ReplicatedStorage.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount
local px = use_px.px

local function TestContent(props)
	return {
		vlayout {
			pad = padding_types.px16,
		},
		padding {
			left = padding_types.px16,
			right = function()
				return UDim.new(0, px(100))
			end,
			y = padding_types.px32,
		},
		RouberOrderCard {
			click = function() end,
			deliverykindimg = assets.images["food.png"],
			extradetails = "Half and Half Chicken",
			height = function()
				return px(100)
			end,
			order = 1,
			restaurantname = "Top Chicken",
			reward = 100,
		},
		RouberOrderCard {
			click = function() end,
			deliverykindimg = assets.images["food.png"],
			extradetails = "Half and Half Chicken",
			height = function()
				return px(100)
			end,
			order = 2,
			restaurantname = "Top Chicken",
			reward = 100,
		},
	} :: { any }
end

local function TestSidePanelContent(props)
	return {
		frame {
			size = UDim2.new(1, 0, 1, 0),
			color = Color3.fromRGB(100, 20, 180),
			transparency = 0.5,
		},
	}
end

local function story()
	use_px.use_px()

	return RouberDashboard {
		original_canvas_size = Vector2.new(1280, 720),
		content = {},
		panelcontent = {},
		DashboardContent {
			content = TestContent {},
			panelcontent = TestSidePanelContent {},
			original_canvas_size = Vector2.new(1280, 720),
		},
	}
end

return function(target)
	return mount(story, target)
end
