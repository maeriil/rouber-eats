local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local entry_card_props = require(ReplicatedStorage.client.app.features.RuberApp.entry_card_props)
local entry_ribbon = require(ReplicatedStorage.client.app.features.RuberApp.Ribbons.entry_ribbon)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local icon = require(ReplicatedStorage.client.app.components.icon.icon)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local slight_rounded = require(ReplicatedStorage.client.app.components.corner.slight_rounded)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local textstroke = require(ReplicatedStorage.client.app.components.border.textstroke)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local read = vide.read
local px = use_px.px
local create = vide.create

type can<T> = T | () -> T
type EntryCardProps = entry_card_props.EntryCardDetails
type props = {
	details: can<EntryCardProps>,
	order: can<number>?,
}

local function entry_card_default(props: props)
	local expected_size = function()
		return UDim2.new(1, 0, 0, px(200))
	end
	local pad_16 = function()
		return UDim.new(0, px(16))
	end
	local pad_8 = function()
		return UDim.new(0, px(8))
	end
	local nopad = function()
		return UDim.new()
	end
	local order = next_order()
	local deliverykind = function()
		local details = read(props.details) :: EntryCardProps

		return details.type
	end

	return frame {
		-- color = Color3.fromRGB(0, 0, 255),
		name = "entrycard_default",
		order = props.order,
		size = expected_size,
		create "UICorner" {
			CornerRadius = pad_16,
		},
		padding {
			padding = pad_16,
		},
		hlayout {
			pad = pad_16,
		},
		pane {
			order = order(),
			size = UDim2.new(1, 0, 1, 0),
			flexfill {},
			vlayout {
				pad = pad_16,
				halign = Enum.HorizontalAlignment.Left,
			},
			entry_ribbon {
				kind = deliverykind,
				order = order(),
			},
			frame {
				color = Color3.fromRGB(255, 0, 0),
				size = function()
					return UDim2.new(1, 0, 0, px(64))
				end,
				order = order(),
				padding {
					padding = pad_16,
				},
			},
			frame {
				color = Color3.fromRGB(0, 255, 0),
				size = function()
					return UDim2.new(1, 0, 0, px(32))
				end,
				hlayout {
					pad = pad_8,
					halign = Enum.HorizontalAlignment.Left,
				},
				order = order(),
				padding {
					x = pad_16,
					y = nopad,
				},
				pane {
					order = 1,
					size = UDim2.new(1, 0, 1, 0),
					square {},
					icon {
						img = assets.images["achievement.png"],
						color = Color3.fromRGB(),
					},
				},
				pane {
					size = UDim2.new(1, 0, 1, 0),
					flexfill {},
					order = order(),
					par {
						text = text_sizes.bolded("10 min (10.1 km) total"),
					},
				},
			},
		},
		frame {
			color = Color3.fromRGB(255, 0, 0),
			size = UDim2.new(1, 0, 1, 0),
			create "UICorner" {
				CornerRadius = pad_16,
			},
			square {},
			order = order(),
		},
	}
end

return entry_card_default
