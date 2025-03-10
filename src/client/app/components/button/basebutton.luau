local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create
local read = vide.read
type props = {
	size: can<UDim2>?,
	order: can<number>?,
	pos: can<UDim2>?,
	anchor: can<UDim2>?,
	disabled: can<boolean>?,
	click: () -> (),
	hoverenter: (() -> ())?,
	hoverleave: (() -> ())?,

	[number]: any,
}

local function basebutton(props: props)
	local function activated()
		if read(props.disabled) then
			return
		end
		props.click()
	end

	local function hoverenter()
		if not props.hoverenter or read(props.disabled) then
			return
		end
		props.hoverenter()
	end

	local function hoverleave()
		if not props.hoverleave or read(props.disabled) then
			return
		end
		props.hoverleave()
	end

	return create "ImageButton" {
		Size = props.size or UDim2.fromScale(1, 1),
		LayoutOrder = props.order or 0,
		Position = props.pos,
		AnchorPoint = props.anchor,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,

		Activated = activated,
		MouseEnter = hoverenter,
		MouseLeave = hoverleave,

		unpack(props),
	}
end

return basebutton
