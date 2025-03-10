local ReplicatedStorage = game:GetService("ReplicatedStorage")
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
type props = {
	text: can<string>,
	size: can<number>?,
	xalign: can<Enum.TextXAlignment>?,
	type: can<string>?,
	wrap: can<boolean>?,
	color: can<Color3>?,
	[number]: any,
}

local px = use_px.px
local create = vide.create
local read = vide.read

local function par(props: props)
	local color = Color3.fromRGB(60, 60, 60)

	return create "TextLabel" {
		Text = props.text,
		Size = UDim2.new(1, 0, 1, 0),
		TextSize = function()
			-- set the type here
			return read(props.size) or px(text_sizes.heading.p)
		end,
		FontFace = text_sizes.font,
		TextColor3 = props.color or color,
		TextXAlignment = props.xalign or Enum.TextXAlignment.Left,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		RichText = true,
		TextWrapped = props.wrap or false,

		unpack(props),
	}
end

return par
