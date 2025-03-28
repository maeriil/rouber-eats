local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ActionKey = require(script.Parent.ActionKey)
local ActionName = require(script.Parent.ActionName)
local MultiTextActionName = require(script.Parent.MultiTextActionName)
local ProximityText = require(script.Parent.ProximityText)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local letter_effect_list = require(ReplicatedStorage.common.utility.letter_effect_list)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local scale = require(ReplicatedStorage.client.app.components.scale.scale)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local mount = vide.mount

local effects = letter_effect_list

-- 2. Jagged Peaks (Alternating Big and Small)

local function story()
	use_px.use_px()

	return frame {
		size = UDim2.new(1, 0, 1, 0),
		color = Color3.fromRGB(255, 0, 0),
		padding {
			padding = padding_types.px32,
		},
		vlayout {
			halign = Enum.HorizontalAlignment.Left,
			pad = function()
				return UDim.new(0, 56)
			end,
		},
		ActionKey {
			letter = "E",
			scale {
				scale = 3,
			},
		},
		ProximityText {
			text = "A sample message",
		},
		ActionName {
			text = "CHATTER..",
			effecttype = effects.extremeWaveSize,
		},
		ActionName {
			text = "HURRY!",
			effecttype = effects.chaoticBounceSize,
		},
		ActionName {
			text = "DÉPÊCHEZ-VOUS!",
			effecttype = effects.inverseZigzagSize,
		},
		MultiTextActionName {
			text = {
				"HOLD",
				"UP!",
			},
			effecttype = effects.mWave,
			mainsize = 120,
			shake = true,
		},
		-- ActionName {
		-- 	text = "LEAVE",
		-- 	effecttype = expDecaySize,
		-- },
		-- ActionName {
		-- 	text = "OPEN",
		-- 	effecttype = inverseZigzagSize,
		-- },
	}
end

return function(target)
	return mount(story, target)
end
