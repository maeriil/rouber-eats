-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local graffiti          = require(ReplicatedStorage.common.configs.gamefont.graffiti)
local vide              = require(ReplicatedStorage.pkg.vide)
local create            = vide.create

type can<T> = T?
type props = {
  letter         : () -> string,
  order          : () -> number,

  primary_color  : Color3,
  secondar_color : Color3,

  thickness      : can<() -> number>,
  rotation       : can<() -> number>,
  transparency   : can<() -> number>,
  stransparency  : can<() -> number>,
  italic         : can<boolean>,
}
-- stylua: ignore end

local function single_scaled_graffiti(props: props)
	local font = graffiti.font
	local stroke_color = props.secondar_color:ToHex()
	local stroke_thickness = function()
		return if props.thickness then props.thickness() else 2
	end
	local stroke_transparency = function()
		return if props.stransparency then props.stransparency() else 0
	end

	local text = function()
		local t =
			`<stroke color="#{stroke_color}" joins="round" thickness="{stroke_thickness()}" transparency="{stroke_transparency()}"><b><font>{props.letter()}</font></b></stroke>`

		if props.italic then
			t = `<i>{t}</i>`
		end

		return t
	end

	return create "TextLabel" {
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		RichText = true,
		TextScaled = true,
		TextWrapped = false,
		TextColor3 = props.primary_color,
		TextTransparency = props.transparency,
		Rotation = props.rotation,
		BackgroundTransparency = 1,
		Name = "graffiti_letter",
		FontFace = font,
		Text = text,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
	}
end

return single_scaled_graffiti
