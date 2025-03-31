local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrencyHUD = require(script.Parent.CurrencyHUD)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount
local source = vide.source
local px = use_px.px

local function story()
	local order = next_order()
	use_px.use_px()

	local curr1 = source(3823823)
	local curr2 = source(123132)

	return frame {
		size = UDim2.new(1, 0, 1, 0),
		color = Color3.fromRGB(0, 100, 250),
		padding {
			padding = padding_types.px32,
		},

		vlayout {},
		pane {
			order = order(),
			size = function()
				return UDim2.new(0, px(500), 0, px(200))
			end,
			CurrencyHUD {
				curr1 = curr1,
				curr2 = curr2,
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
