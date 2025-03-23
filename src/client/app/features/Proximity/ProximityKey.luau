local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local vide = require(ReplicatedStorage.pkg.vide)
type props = {
	letter: string,
	inverted: boolean?,
}

local create = vide.create
local read = vide.read

local function ProximityActionKey(props: props)
	-- Letsjust constantly spin the hexagon?

	local textcolor = Color3.fromRGB(0, 255, 255)
	local foreground = if props.inverted
		then Color3.fromRGB(255, 255, 255)
		else Color3.fromRGB(0, 0, 0)
	local hexagoncolor = if props.inverted
		then Color3.fromRGB(0, 0, 0)
		else Color3.fromRGB(255, 255, 255)

	local rotationmotion, motion = use_motion(0)
	motion:tween(360, {
		delayTime = 0,
		direction = Enum.EasingDirection.Out,
		repeatCount = -1,
		reverses = false,
		style = Enum.EasingStyle.Linear,
		time = 5,
	})

	return {

		create "ImageLabel" {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = assets.images["Hexagon.svg"],
			ImageColor3 = hexagoncolor,
			Rotation = rotationmotion,
			square {},

			frame {
				color = foreground,
				size = function()
					return UDim2.new(0.75, 0, 0.75, 0)
				end,
				circle {},
				anchor = Vector2.new(1, 0.5),
				pos = UDim2.fromScale(1, 0.5),
				create "TextLabel" {
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.fromScale(0.5, 0.5),
					Rotation = function()
						return -rotationmotion()
					end,
					TextScaled = true,
					RichText = true,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					Text = function()
						return `<b>{read(props.letter)}</b>`
					end,
					TextColor3 = textcolor,
				},
			},
		},
	}
end

return ProximityActionKey
