local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)
--[[
  This is exact same as the SpeechBubble component but uses Scale value instead as we
  typically use this in a billboardgui

  BUG JITTERY TEXT
  The text becomes jittery when we move close or far from the bubble, tbh idk the fix
  relevant blog post: https://devforum.roblox.com/t/scaled-rich-text-on-a-billboardgui-keeps-shaking/2570177
]]

local create = vide.create
local read = vide.read

type props = {
	click: () -> (),
	text: types.Can<string>,
	animate: types.Can<boolean>?,
}

local function SpeechBubble(props: props)
	return pane {
		size = UDim2.new(1, 0, 1, 0),

		basebutton {
			click = props.click,
		},

		create "ImageLabel" {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Image = assets.images["SpeechBubbleInverted.svg"],

			create "TextLabel" {
				RichText = true,
				Text = `<b>{read(props.text)}</b>`,
				-- Text = `<b>please talk to me</b>`,
				Size = UDim2.fromScale(0.7, 0.4),
				AnchorPoint = Vector2.new(0.5, 0),
				Position = UDim2.fromScale(0.5, 0.2),
				TextWrapped = true,
				TextScaled = true,
				-- TextSize = 32,
				-- TextXAlignment = Enum.TextXAlignment.Center,
				BackgroundTransparency = 1,
				TextColor3 = Color3.fromRGB(255, 255, 255),
			},
		},
	}
end

return SpeechBubble
