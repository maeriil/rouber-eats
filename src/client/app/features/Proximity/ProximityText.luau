local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

type props = {
	inverted: boolean?,
	text: types.Can<string>,
	rotation: types.Can<number>?,
}

local read = vide.read
local create = vide.create

local function ProximityText(props: props)
	local background = if props.inverted
		then Color3.fromRGB()
		else Color3.fromRGB(255, 255, 255)
	local foreground = if props.inverted
		then Color3.fromRGB(255, 255, 255)
		else Color3.fromRGB()

	return frame {
		size = UDim2.new(1, 0, 1, 0),
		color = background,
		rotation = props.rotation,

		create "TextLabel" {
			RichText = true,
			Size = UDim2.fromScale(0.9, 0.9),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Text = `<b>{read(props.text)}</b>`,
			TextScaled = true,
			BackgroundTransparency = 1,
			TextColor3 = foreground,
		},
	}
end

return ProximityText
