local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Proximity = require(script.Parent)
local ProximityDistanceIcon = require(script.Parent.ProximityDistanceIcon)
local assets = require(ReplicatedStorage.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount

local function story()
	local order = next_order()

	return frame {
		color = Color3.fromRGB(0, 100, 200),
		padding {
			padding = padding_types.px48,
		},
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		vlayout {},
		Proximity {
			action = "LEAVE!",
			actionkey = "X",
			proximitytext = "The house",
			order = order,
		},
		Proximity {
			action = "ENTER!",
			actionkey = "E",
			proximitytext = "Kim's Restaurant",
			order = order,
		},
		pane {
			size = function()
				return UDim2.new(1, 0, 0, 150)
			end,
			hlayout {
				halign = Enum.HorizontalAlignment.Center,
				pad = padding_types.px16,
			},
			ProximityDistanceIcon {
				rotation = 30,
				inverted = true,
			},
			ProximityDistanceIcon {
				rotation = 80,
				inverted = true,
				icon = assets.images["tutorial.png"],
			},
			ProximityDistanceIcon {
				rotation = 128,
				inverted = true,
				icon = assets.images["checklist.png"],
			},
			ProximityDistanceIcon {
				rotation = 170,
				inverted = true,
				icon = assets.images["information.png"],
			},
			ProximityDistanceIcon {
				rotation = 0,
				inverted = true,
				icon = assets.images["wifi.png"],
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
