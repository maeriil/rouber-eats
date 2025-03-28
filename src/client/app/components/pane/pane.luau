local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
type can<T> = T | () -> T

export type props = {
	name: can<string>?,
	size: can<UDim2>,
	pos: can<UDim2>?,
	anchor: can<Vector2>?,
	order: can<number>?,
	zindex: can<number>?,
	rotation: can<number>?,
	clips: can<boolean>?,

	[number]: any,
}

local function pane(props: props)
	return create "Frame" {
		Size = props.size,
		Position = props.pos or UDim2.new(0, 0, 0, 0),
		AnchorPoint = props.anchor or Vector2.new(0, 0),
		LayoutOrder = props.order or 0,
		Name = props.name or "Pane",
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
		ZIndex = props.zindex,
		Rotation = props.rotation,
		ClipsDescendants = props.clips,

		unpack(props),
	}
end

return pane
