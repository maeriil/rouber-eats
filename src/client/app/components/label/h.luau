local ReplicatedStorage = game:GetService("ReplicatedStorage")
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
type props = {
	text: can<string>,
	xalign: can<Enum.TextXAlignment>?,
	type: can<string>?,
}

local px = use_px.px
local create = vide.create

local function h(props: props)
	local color = Color3.fromRGB(60, 60, 60)

	return create "TextLabel" {
		Text = props.text,
		Size = UDim2.new(1, 0, 1, 0),
		TextSize = function()
			-- set the type here
			return px(text_sizes.heading.h1)
		end,
		FontFace = text_sizes.font,
		TextColor3 = color,
		TextXAlignment = props.xalign or Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}
end

return h
