local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExclamationIcon = require(ReplicatedStorage.client.app.features.Icons.ExclamationIcon)
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create
local read = vide.read

type props = {
	order: types.Can<number>?,
	click: () -> (),
	text: types.Can<string>,
}

local function SpeechBubble(props: props)
	return pane {
		size = function()
			return UDim2.new(0, px(371), 0, px(190))
		end,
		order = props.order,
		basebutton {
			click = props.click,
		},
		create "ImageLabel" {
			Size = UDim2.new(0, px(375), 0, px(202)),
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = assets.images["SpeechBubbleInverted.svg"],
			padding {
				padding = padding_types.px36,
			},
			pane {
				size = UDim2.fromScale(1, 0.75),
				anchor = Vector2.new(0.5, 0),
				pos = UDim2.fromScale(0.5, 0),

				par {
					text = function()
						return text_sizes.bolded(read(props.text))
					end,
					color = Color3.fromRGB(255, 255, 255),
					size = function()
						return px(text_sizes.heading.h4)
					end,
					wrap = true,
					xalign = Enum.TextXAlignment.Center,
				},
			},
		},
		ExclamationIcon {
			anchor = Vector2.new(1, 0),
			pos = UDim2.new(1, 0, 0, -px(32)),
		},
	}
end

return SpeechBubble
