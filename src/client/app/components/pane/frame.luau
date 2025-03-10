local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
type can<T> = T | () -> T

type props = {
	name: can<string>?,
	size: can<UDim2>,
	pos: can<UDim2>?,
	anchor: can<Vector2>?,
	order: can<number>?,
	color: can<Color3>?,
	zindex: can<number>?,
	rotation: can<number>?,
	autosz: can<Enum.AutomaticSize>?,
	-- color: can<ColorSequence>?,
	transparency: can<number>?,
	-- colorrot: can<number>?,

	[number]: any,
}

local function frame(props: props)
	return create "Frame" {
		Size = props.size,
		Position = props.pos or UDim2.new(0, 0, 0, 0),
		AnchorPoint = props.anchor or Vector2.new(0, 0),
		LayoutOrder = props.order or 0,
		Name = props.name or "Frame",
		BackgroundTransparency = props.transparency or 0,
		BackgroundColor3 = props.color or Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = props.zindex,
		Rotation = props.rotation,
		AutomaticSize = props.autosz or Enum.AutomaticSize.None,

		-- we should instead pass it as props if we need to
		-- create "UIGradient" {
		-- 	Color = props.color,
		-- 	Transparency = props.transparency or 0,
		-- 	Rotation = props.colorrot or 0,
		-- 	Offset = 0,
		-- },

		unpack(props),
	}
end

return frame
