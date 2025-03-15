local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local par = require(ReplicatedStorage.client.app.components.label.par)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local show = vide.show
local px = use_px.px

type props = {
	details: types.Source<types.DeliveryOrderType>,
	acceptclick: () -> (),
	showaccept: types.Source<boolean>,
}

local function AcceptButton(props: {
	click: () -> (),
	order: types.Can<number>,
})
	--[[
  TODO Make this better..
  ]]

	return frame {
		color = Color3.fromRGB(0, 255, 0),
		size = function()
			return UDim2.new(1, 0, 0, px(64))
		end,
		order = props.order,
		padding {
			padding = padding_types.px16,
		},
		basebutton {
			click = props.click,
		},
		par {
			text = "Accept",
			size = function()
				return px(text_sizes.heading.h2)
			end,
			xalign = Enum.TextXAlignment.Center,
		},
	}
end

local function OrderPanelView(props: props)
	local order = next_order()

	return {
		padding {
			y = padding_types.px32,
			x = padding_types.nopad,
		},
		vlayout {
			pad = padding_types.px32,
		},
		frame {
			color = Color3.fromRGB(180, 50, 50),
			order = order(),
			name = "Restaurant Image container",
			size = function()
				return UDim2.new(1, 0, 0, px(256))
			end,
			par {
				text = function()
					return text_sizes.bolded(props.details().restaurant.name)
				end,
				size = function()
					return px(text_sizes.heading.h2)
				end,
				xalign = Enum.TextXAlignment.Center,
				wrap = true,
			},
		},
		frame {
			order = order(),
			name = "Restaurant Image container",
			size = function()
				return UDim2.new(1, 0, 1, 0)
			end,
			flexfill {},
			par {
				text = function()
					return text_sizes.bolded(`{props.details().reward}`)
				end,
				size = function()
					return px(text_sizes.heading.h2)
				end,
				xalign = Enum.TextXAlignment.Center,
			},
		},
		show(props.showaccept, function()
			return AcceptButton { click = props.acceptclick, order = order() }
		end),
	} :: { unknown }
end

return OrderPanelView
