local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)
--[[
  Whenever we are near a proximity, but not near enough to active the Proximity
  or when we are near multiple proximitys but becuase we can only be closest to one of them
  we still wanna let user know that they are still close to the other proximity
  we use this to display that basically

]]

local create = vide.create
local read = vide.read

type props = {
	icon: types.Can<string>?,
	inverted: types.Can<boolean>?,
	rotation: types.Can<number>?,
}

local function ProximityIcon(props: props)
	local image_icon = props.icon or assets.images["ExclamationIcon.svg"]
	local containericon = if read(props.inverted)
		then assets.images["ActionBubbleInverted.svg"]
		else assets.images["ActionBubble.svg"]

	return create "ImageLabel" {
		Image = containericon,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, 0, 1, 0),
		Rotation = props.rotation,
		BackgroundTransparency = 1,

		create "ImageLabel" {
			Image = image_icon,
			Size = UDim2.new(0.75, 0, 0.75, 0),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.fromScale(0.5, 0),
			Rotation = function()
				return -(read(props.rotation) or 0)
			end,
		},
	}
end

return ProximityIcon
