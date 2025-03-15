local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

type props = {
	scale: types.Can<number>?,
	size: types.Can<UDim2>?,
}
local create = vide.create
local px = use_px.px

local function DialogueIndicator(props: props)
	return create "ImageLabel" {
		Size = props.size or function()
			return UDim2.new(0, px(60), 0, px(40))
		end,
		BackgroundTransparency = 1,
		BackgroundColor3 = Color3.fromRGB(255, 0, 0),
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Image = assets.images["DialogueBubbleIndicator.svg"],

		create "UIScale" {
			Scale = props.scale,
		},
	}
end

return DialogueIndicator
