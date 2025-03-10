local ReplicatedStorage = game:GetService("ReplicatedStorage")
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create
type props = {
	img: can<string>,
	color: can<Color3>?,
	[number]: any,
}

local function icon(props: props)
	return create "ImageLabel" {
		Image = props.img,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		ImageColor3 = props.color,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),

		square {},
		unpack(props),
	}
end

export type icontype = typeof(icon)

return icon
