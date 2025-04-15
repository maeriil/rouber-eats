-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basefont          = require(ReplicatedStorage.common.configs.gamefont.basefont)
local vide              = require(ReplicatedStorage.pkg.vide)
local create            = vide.create

--[[
  SText means that it is TextScaled
]]

type can<T>   = T?
type props    = {
  text          : () -> string,
  bolded        : can<boolean>,
  xbolded       : can<boolean>;
  italic        : can<boolean>,
  color         : can<() -> Color3>,
  xalign        : can<Enum.TextXAlignment>,
  yalign        : can<Enum.TextYAlignment>,
  wrap          : can<boolean>;
  ttransparency : can<number | () -> number>;
  [number] : any
}
-- stylua: ignore end

local function text(props: props)
	local font = if props.xbolded then basefont.extrabolded else basefont.font

	return create "TextLabel" {
		RichText = true,
		Text = function()
			local t = `{props.text()}`
			if props.bolded then
				t = `<b>{t}</b>`
			end
			if props.italic then
				t = `<i>{t}</i>`
			end

			return t
		end,
		FontFace = font,
		TextScaled = true,
		TextColor3 = props.color or function()
			return Color3.fromRGB()
		end,
		BackgroundTransparency = 1,
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		Position = function()
			return UDim2.new(0.5, 0, 0.5, 0)
		end,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BorderSizePixel = 0,
		TextXAlignment = props.xalign or Enum.TextXAlignment.Center,
		TextYAlignment = props.yalign or Enum.TextYAlignment.Center,
		TextWrapped = props.wrap or false,
		TextTransparency = props.ttransparency or 0,
		unpack(props),
	}
end

return text
