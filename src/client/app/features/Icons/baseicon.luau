local ReplicatedStorage = game:GetService("ReplicatedStorage")
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
type props = {
	img: types.Can<string>,
	color: types.Can<Color3>?,
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
		ImageTransparency = 0,

		square {},
		unpack(props),
	}
end

export type icontype = typeof(icon)

return icon
