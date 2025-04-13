local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)
local create = vide.create

type can<T> = T?
type props = {
	img: string | () -> string,
	pos: can<() -> UDim2>,
	anchor: can<() -> Vector2>,
	size: can<() -> UDim2>,
	transparency: can<() -> number>,
	color: can<() -> Color3>,
	zindex: can<() -> number>,
	[number]: any,
}

local function base_image(props: props)
	return create "ImageLabel" {
		AnchorPoint = props.anchor or Vector2.new(0.5, 0.5),
		Position = props.pos or function()
			return UDim2.fromScale(0.5, 0.5)
		end,
		Size = props.size or function()
			return UDim2.new(1, 0, 1, 0)
		end,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(0, 255, 0),
		BorderSizePixel = 0,
		ImageTransparency = props.transparency or 0,
		Image = props.img,
		ImageColor3 = props.color or Color3.fromRGB(255, 0, 0),
		ZIndex = props.zindex,

		unpack(props),
	}
end

return base_image
