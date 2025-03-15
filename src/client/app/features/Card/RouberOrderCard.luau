local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local baseicon = require(ReplicatedStorage.client.app.features.Icons.baseicon)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local read = vide.read
local px = use_px.px
local create = vide.create

type props = {
	click: () -> (),
	order: types.Can<number>,
	height: types.Can<number>,
	content: types.DeliveryOrderType,
}

local function order_card(props: props)
	local order = next_order()
	local bolded = text_sizes.bolded

	return frame {
		size = function()
			return UDim2.new(1, 0, 0, read(props.height))
		end,
		basebutton {
			click = props.click,
		},
		color = Color3.fromRGB(200, 200, 200),
		transparency = 0,
		create "UICorner" {
			CornerRadius = padding_types.px8,
		},

		pane {
			size = UDim2.new(1, 0, 1, 0),
			padding {
				x = padding_types.px16,
				y = padding_types.px8,
			},
			hlayout {
				pad = padding_types.px16,
			},
			baseicon {
				order = order(),
				img = assets.images["ExclamationIcon.svg"],
			},
			pane {
				name = "middle-text",
				size = UDim2.new(1, 0, 1, 0),
				order = order(),
				flexfill {},
				vlayout { pad = padding_types.nopad },
				pane {
					size = function()
						return UDim2.new(1, 0, 0.5, 0)
					end,
					par {
						text = function()
							local res_name = props.content.restaurant.name
							return bolded(res_name)
						end,
						size = function()
							return px(text_sizes.heading.h3)
						end,
					},
				},
				pane {
					size = function()
						return UDim2.new(1, 0, 0.5, 0)
					end,
					par {
						text = function()
							local dist = props.content.distance
							local reward = props.content.reward

							return bolded(`Distance = {dist}, Reward = {reward}`)
						end,
						size = function()
							return px(text_sizes.heading.h4)
						end,
					},
				},
			},
			vide.create "ImageLabel" {
				Name = "figma-uploaded-image-create-in-its-own-file",
				LayoutOrder = order(),
			},
		},
	}
end

return order_card
