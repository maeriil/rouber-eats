local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local colorscheme = require(ReplicatedStorage.client.store.colorscheme)

local px = use_px.px

type props = {}

local function order_receipt(props)
	local function white_background()
		return colorscheme.pure_white
	end

	return frame {
		color = colorscheme.matte_black,
		transparency = 0.25,

		pane {
			size = function()
				return UDim2.new(0, px(764), 0, px(940))
			end,
			baseimage {
				img = assets.images["receipt_container.svg"],
				color = white_background,
			},
			pane {
				size = function()
					return UDim2.new(1, -px(108), 1, 0)
				end,
				pos = UDim2.new(1, 0, 0, 0),
				anchor = Vector2.new(1, 0),
				padding {
					y = padding_types.px32,
					x = padding_types.nopad,
				},
				vlayout {
					pad = padding_types.px16,
				},
				pane {
					name = `title-container`,
					size = function()
						return UDim2.new(0, px(384), 0, px(96))
					end,
					baseimage {
						img = assets.images["JaegarsCafeLogo.svg"],
						color = white_background,
					},
				},
				frame {
					name = "food-money-container",
					size = function()
						return UDim2.new(0, px(560), 0, px(400))
					end,
				},
				frame {
					name = "conditions-and-misc-details",
					size = function()
						return UDim2.new(0, px(560), 0, px(256))
					end,
				},
			},
		},
	}
end

return order_receipt
