local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local read = vide.read
local px = use_px.px

type props = {
	click: () -> (),
	deliverykindimg: string,
	restaurantname: types.Can<string>,
	extradetails: types.Can<string>,
	reward: types.Can<number>,
	order: types.Can<number>,
	height: types.Can<number>,
}

local function icon(props: {})
	return vide.create "ImageLabel" {
		vide.create "UIAspectRatioConstraint" {},
	}
end

local function order_card(props: props)
	local order = next_order()

	return frame {
		size = function()
			return UDim2.new(1, 0, 0, read(props.height))
		end,
		basebutton {
			click = props.click,
		},

		pane {
			size = UDim2.new(1, 0, 1, 0),
			padding {
				x = padding_types.px16,
				y = padding_types.px4,
			},
			hlayout {
				padding = padding_types.px16,
			},
			icon {
				order = order(),
				img = props.deliverykindimg,
			},
			pane {
				name = "middle-text",
				size = UDim2.new(1, 0, 1, 0),
				order = order(),
				flexfill {},
			},
			vide.create "ImageLabel" {
				Name = "figma-uploaded-image-create-in-its-own-file",
				LayoutOrder = order(),
			},
		},
	}
end

return order_card
