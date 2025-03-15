local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local px = use_px.px
local read = vide.read

type props = {
	scale: types.Can<number>?,
	pos: types.Can<UDim2>?,
	anchor: types.Can<Vector2>?,
	author: types.Can<string>,
}

local function DialogueAuthor(props: props)
	local scale = props.scale or 1

	return pane {
		size = function()
			return UDim2.new(0, px(292), 0, px(81))
		end,
		pos = props.pos,
		anchor = props.anchor,
		create "UIScale" {
			Scale = scale,
		},
		create "ImageLabel" {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = assets.images["DialogueUsername.svg"],
			padding {
				x = padding_types.px16,
				y = padding_types.px4,
			},
			pane {
				rotation = -4,
				color = Color3.fromRGB(0, 0, 255),
				size = function()
					return UDim2.new(1, 0, 0.5, 0)
				end,
				pos = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				anchor = Vector2.new(0.5, 0.5),
				par {
					text = function()
						return text_sizes.bolded(read(props.author))
					end,
					size = function()
						return px(text_sizes.heading.h3)
					end,
					xalign = Enum.TextXAlignment.Center,
					wrap = true,
				},
			},
		},
	}
end

return DialogueAuthor
