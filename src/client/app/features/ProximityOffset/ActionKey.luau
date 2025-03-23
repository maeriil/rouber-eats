local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types =
	require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local px = use_px.px
local effect = vide.effect
local action = vide.action

type props = {
	letter: string,
	noanimate: boolean?,
	pos: types.Can<UDim2>?,
	anchor: types.Can<Vector2>?,
}

local function ActionKey(props: props)
	-- Hexagon
	-- spinning animation
	-- bordered and contains circular icon with Keyboard Key

	local textcolor = Color3.fromRGB(0, 255, 255)
	local foreground = Color3.fromRGB(0, 0, 0)
	local hexagoncolor = Color3.fromRGB(255, 255, 255)

	local bounce, bouncemotion = use_motion(UDim2.new(1, 0, 0.5, 0))

	return pane {
		action(function(a0: Instance)
			-- bouncemotion:tween(UDim2.new(1, 0, 1, 0), {
			-- 	delayTime = 0,
			-- 	direction = Enum.EasingDirection.Out,
			-- 	repeatCount = -1,
			-- 	reverses = true,
			-- 	style = Enum.EasingStyle.Exponential,
			-- 	time = 1,
			-- })
		end),

		-- size = function()
		-- 	return UDim2.new(0, px(64), 0, px(64))
		-- end,
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		square {},

		unpack(props),
		create "ImageLabel" {
			BackgroundTransparency = 1,
			Image = assets.images["Hexagon.svg"],
			ImageColor3 = hexagoncolor,
			square {},
			Position = props.pos,
			AnchorPoint = props.anchor,
			Size = function()
				-- return UDim2.new(0, px(64), 0, px(64))
				return UDim2.new(0.9, 0, 0.9, 0)
			end,
			-- padding {
			-- 	padding = padding_types.px4,
			-- },
			frame {
				color = foreground,
				size = function()
					return UDim2.new(0.75, 0, 0.75, 0)
				end,
				circle {},
				anchor = Vector2.new(1, 0.5),
				pos = bounce,
				-- padding {
				-- 	padding = padding_types.px4,
				-- },
				create "TextLabel" {
					Rotation = 0,
					RichText = true,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Text = function()
						return text_sizes.bolded(props.letter)
					end,
					TextColor3 = textcolor,
					TextSize = function()
						return px(32)
					end,
					Size = function()
						return UDim2.new(1, 0, 1, 0)
					end,
					Position = function()
						return UDim2.new(0.5, 0, 0.5, 0)
					end,
					AnchorPoint = Vector2.new(0.5, 0.5),
				},
			},
		},
	}
end

return ActionKey
