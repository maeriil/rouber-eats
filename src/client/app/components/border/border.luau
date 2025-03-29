local ReplicatedStorage = game:GetService("ReplicatedStorage")
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create

type props = {
	linemode: can<Enum.LineJoinMode>?,
	thickness: can<number>?,
	transparency: can<number>?,
	color: can<Color3>?,
	[number]: Instance, -- We want to pass UIGradient instead of setting colour
}

local px = use_px.px

local function border(props: props)
	return create "UIStroke" {
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Color = props.color or Color3.fromRGB(255, 255, 255),
		LineJoinMode = props.linemode or Enum.LineJoinMode.Round,
		Thickness = props.thickness or function()
			return px(4)
		end,
		Transparency = props.transparency or function()
			return 0
		end,
		unpack(props),
	}
end

return border
