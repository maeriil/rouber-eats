local ReplicatedStorage = game:GetService("ReplicatedStorage")
local entry_card = require(script.Parent.entry_card)
local entry_card_expanded = require(script.Parent.entry_card_expanded)
local entry_card_minimal = require(script.Parent.entry_card_minimal)
local entry_card_props = require(ReplicatedStorage.client.app.features.RuberApp.entry_card_props)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount
local px = use_px.px

type EntryCardProps = entry_card_props.EntryCardDetails

local function story()
	use_px.use_px()
	local order = next_order()
	local details: EntryCardProps = {
		order_id = "12312312",
		type = "delivery",
		delivery_rating = 3,
		payment = 10.25,
		distance = 10,
		time = 10,
		reputation_points = 20,

		restaurant_name = "Wendys",
		restaurant_address = "10 something something",
		dist_to_restaurant = 5,
		time_to_restaurant = 5,
		orders = {},

		dest_address = "5 gilroy",
		dist_to_dest_from_restaurant = 5,
		time_to_dest_from_restaurant = 5,
		expected_tips = 2.5,
		additional_instructions = {},
	}

	return frame {
		color = Color3.fromRGB(150, 150, 150),
		size = UDim2.new(0, px(500), 1, 0),
		anchor = Vector2.new(0.5, 0.5),
		pos = UDim2.new(0.5, 0, 0.5, 0),
		padding {
			y = function()
				return UDim.new(0, px(64))
			end,
		},
		vlayout {
			pad = function()
				return UDim.new(0, px(32))
			end,
		},
		entry_card {
			details = details,
			order = order(),
		},
		entry_card_expanded {
			details = details,
			order = order(),
		},
		entry_card_minimal {
			details = details,
			order = order(),
		},
	}
end

return function(target)
	return mount(story, target)
end
