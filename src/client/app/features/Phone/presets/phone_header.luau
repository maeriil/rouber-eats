local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local icon = require(ReplicatedStorage.client.app.components.icon.icon)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local textstroke = require(ReplicatedStorage.client.app.components.border.textstroke)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)

local px = use_px.px

local function phone_header()
	local order = next_order()

	return {
		hlayout {
			pad = function()
				return UDim.new(0, px(36))
			end,
		},
		padding {
			y = function()
				return UDim.new(0, px(4))
			end,
			x = function()
				return UDim.new(0, 0)
			end,
		},
		pane {
			size = UDim2.new(1, 0, 1, 0),
			order = order(),
			flexfill {},
			par {
				text = text_sizes.bolded("9:20"),
				size = function()
					return px(22)
				end,
				color = Color3.fromRGB(255, 255, 255),
				xalign = Enum.TextXAlignment.Right,
				textstroke {
					thickness = 1,
					color = Color3.fromRGB(),
				},
			},
		},
		frame {
			size = function()
				return UDim2.new(0, px(160), 1, 0)
			end,
			order = order(),
			color = Color3.fromRGB(),
			circle {},
		},
		pane {
			size = UDim2.new(1, 0, 1, 0),
			order = order(),
			flexfill {},
			padding {
				y = function()
					return UDim.new(0, px(6))
				end,
				x = function()
					return UDim.new(0, 0)
				end,
			},
			hlayout {
				pad = function()
					return UDim.new(0, px(12))
				end,
			},
			pane {
				order = order(),
				size = UDim2.new(1, 0, 1, 0),
				square {},
				icon {
					img = assets.images["signal.png"],
				},
			},
			pane {
				order = order(),
				size = UDim2.new(1, 0, 1, 0),
				square {},
				icon {
					img = assets.images["wifi.png"],
				},
			},
			pane {
				order = order(),
				size = UDim2.new(1, 0, 1, 0),
				square {},
				icon {
					img = assets.images["battery_full.png"],
				},
			},
		},
	}
end

return phone_header
