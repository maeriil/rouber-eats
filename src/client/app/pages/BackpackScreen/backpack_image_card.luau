local ReplicatedStorage = game:GetService("ReplicatedStorage")

local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local scale = require(ReplicatedStorage.client.app.components.scale.scale)
local backpack_base_card =
	require(ReplicatedStorage.client.app.pages.BackpackScreen.backpack_base_card)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local vide = require(ReplicatedStorage.pkg.vide)

type props = {
	image: () -> string,
	[number]: any,
	-- shake: () -> boolean,
}

-- local effect = vide.effect

local function backpack_image_card(props: props): { any }
	local rot, rotm = use_motion(0)

	-- effect(function()
	-- 	if props.shake() then
	-- 		rotm:tween(10, {
	-- 			delayTime = 1,
	-- 			direction = Enum.EasingDirection.InOut,
	-- 			repeatCount = -1,
	-- 			reverses = true,
	-- 			style = Enum.EasingStyle.Linear,
	-- 			time = 0.5,
	-- 		})
	-- 	end
	-- end)

	return {
		backpack_base_card {},
		unpack(props),
		pane {
			scale {
				scale = 0.75,
			},
			anchor = Vector2.new(0.5, 0.5),
			pos = UDim2.new(0.5, 0, 0.5, 0),
			rotation = rot,
			baseimage {
				img = props.image,
				color = function()
					return Color3.fromRGB(255, 255, 255)
				end,
				square {},
			},
		},
	}
end

return backpack_image_card
