local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RouberPhone = require(ReplicatedStorage.client.app.features.RouberPhone)
local TaxiButton = require(ReplicatedStorage.client.app.features.Icons.TaxiButton)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local px = use_px.px
local create = vide.create

local function PhoneScreen(props)
	local order = next_order()

	return pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,

		RouberPhone {
			vlayout {
				pad = padding_types.nopad,
			},
			frame {
				name = "phone-top-bar",
				size = function()
					return UDim2.new(1, 0, 0, px(32))
				end,
				color = Color3.fromRGB(255, 0, 0),
				order = order(),
			},
			frame {
				name = "phone-profile-bar",
				size = function()
					return UDim2.new(1, 0, 0, px(240))
				end,
				color = Color3.fromRGB(0, 255, 0),
				order = order(),
			},
			frame {
				name = "phone-profile-bar",
				size = function()
					return UDim2.new(1, 0, 1, 0)
				end,
				color = Color3.fromRGB(0, 0, 255),
				order = order(),
				flexfill {},

				padding {
					x = padding_types.px4,
					y = padding_types.px16,
				},
				create "UIGridLayout" {
					--[[
						TODO:Should turn this into its own component
						We also need to figure out a way to do the following. When we have 4 items
							in the row, then they need to look like center aligned. But when a new item is added
							it needs to go on a new row and be at Left most
					]]
					CellSize = function()
						return UDim2.new(0, math.max(36, px(96)), 0, math.max(52, px(96)))
					end,

					CellPadding = function()
						return UDim2.fromOffset(px(16), px(16))
					end,

					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
				},

				TaxiButton {
					click = function()
						change_page("RouberScreen")
					end,
					order = order,
				},
			},
		},
	}
end

return PhoneScreen
