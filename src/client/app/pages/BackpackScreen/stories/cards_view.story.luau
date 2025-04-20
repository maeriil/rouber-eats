local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local effect2 = require(ReplicatedStorage.client.app.features.ActiveEffect.effect2)
local backpack_base_card =
	require(ReplicatedStorage.client.app.pages.BackpackScreen.backpack_base_card)
local backpack_image_card =
	require(ReplicatedStorage.client.app.pages.BackpackScreen.backpack_image_card)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local px = use_px.px

local function story()
	use_px.use_px()

	local card_size = function()
		return UDim2.new(0, px(128), 0, px(128))
	end

	return frame {
		color = Color3.fromRGB(0, 100, 255),
		size = function()
			return UDim2.new(0.75, 0, 0.75, 0)
		end,
		anchor = Vector2.new(0.5, 0.5),
		pos = UDim2.new(0.5, 0, 0.5, 0),
		vlayout {
			pad = padding_types.px32,
		},
		frame {
			color = Color3.fromRGB(255, 0, 0),
			size = card_size,
			backpack_base_card {},
		},
		pane {
			color = Color3.fromRGB(255, 0, 0),
			size = card_size,

			backpack_image_card {
				image = function()
					return assets.images["TaxiAppIcon.svg"]
				end,
				-- shake = function()
				-- 	return true
				-- end,
				pane {
					anchor = Vector2.new(0.5, 0.5),
					pos = UDim2.new(0.5, 0, 0.5, 0),
					size = function()
						return UDim2.new(0, px(280), 0, px(72))
					end,
					effect2 {},
				},
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
