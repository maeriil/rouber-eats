local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local baseicon = require(script.Parent.baseicon)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local action = vide.action
local px = use_px.px

type props = {
	nospin: types.Can<boolean>?,
	anchor: types.Can<Vector2>?,
	pos: types.Can<UDim2>?,
	size: types.Can<UDim2>?,
}

local function StarIcon(props: props)
	local image = assets.images["ExclamationIcon.svg"]
	local rotation, motion = use_motion(-5)

	motion:tween(5, {
		direction = Enum.EasingDirection.Out,
		repeatCount = -1,
		reverses = true,
		style = Enum.EasingStyle.Bounce,
		time = 0.2,
	})

	return pane {
		size = props.size or function()
			return UDim2.new(0, math.max(px(71), 52), 0, math.max(px(71), 52))
		end,
		anchor = props.anchor,
		pos = props.pos,
		rotation = rotation,

		baseicon {
			img = image,
			color = Color3.fromRGB(255, 255, 255),
		},
	}
end

return StarIcon
