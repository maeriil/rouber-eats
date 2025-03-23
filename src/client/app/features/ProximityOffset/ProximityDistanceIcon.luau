local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
--[[
  By default, anything related to proximity prompt in distance would just be a square
  with some icon

  SO lets say like we are near a door, we first see a square icon, until we approach it, and
  then only it will transition to the full proximity
]]

local create = vide.create
local px = use_px.px
local read = vide.read

type props = {
	icon: types.Can<string>?,
	size: types.Can<UDim2>?,
	inverted: types.Can<boolean>?,
	rotation: types.Can<number>?,
}

local function ProximityDistanceIcon(props: props)
	local image_icon = props.icon or assets.images["ExclamationIcon.svg"]
	local containericon = if read(props.inverted)
		then assets.images["ActionBubbleInverted.svg"]
		else assets.images["ActionBubble.svg"]

	-- we want the actual icon to always be upright

	return pane {
		size = props.size or function()
			return UDim2.new(1, 0, 1, 0)
		end,

		create "ImageLabel" {
			Image = containericon,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, 0, 1, 0),
			Rotation = props.rotation,
			BackgroundTransparency = 1,
			padding {
				padding = padding_types.px16,
			},
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
		},
	}
end

return ProximityDistanceIcon
