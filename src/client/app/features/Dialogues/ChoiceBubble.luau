local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local par = require(ReplicatedStorage.client.app.components.label.par)
local ratio = require(ReplicatedStorage.client.app.components.ratio)
local text_sizes = require(ReplicatedStorage.client.app.utility.text_sizes)
local types = require(ReplicatedStorage.types)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create
local read = vide.read
local source = vide.source
local effect = vide.effect

type props = {
	click: () -> (),
	text: types.Can<string>,
	order: types.Can<number>?,
	inverted: types.Can<boolean>?,
	rotation: types.Can<number>?,
}

local function ChoiceBubble(props: props)
	local hovering = source(false)
	local default_scale = 1
	local pop_scale = 1.05
	local scaleanim, motion = use_motion(default_scale)
	local popout_textcolor = "#8EEDF7"
	local textcolor = function()
		if hovering() then
			return Color3.fromHex(popout_textcolor)
		end
		return if not read(props.inverted) then Color3.fromRGB() else Color3.fromRGB(255, 255, 255)
	end
	local imagecolor = function()
		return if not read(props.inverted) then Color3.fromRGB(255, 255, 255) else Color3.fromRGB()
	end

	effect(function()
		if hovering() then
			motion:tween(pop_scale, {
				direction = Enum.EasingDirection.Out,
				reverses = true,
				repeatCount = -1,
				style = Enum.EasingStyle.Bounce,
				time = 0.2,
			})
		else
			motion:immediate(default_scale)
			motion:tween(default_scale)
		end
	end)
	return pane {
		size = function()
			-- return UDim2.new(0, px(440), 0, px(95))
			return UDim2.new(1, 0, 1, 0)
		end,
		order = props.order,
		basebutton {
			click = props.click,
			hoverenter = function()
				hovering(true)
			end,
			hoverleave = function()
				hovering(false)
			end,
		},
		ratio {
			ratio = 440 / 95,
		},
		create "ImageLabel" {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Image = assets.images["DialogueFlipped.svg"],
			Rotation = props.rotation,
			ImageColor3 = imagecolor,

			-- If we wanted to flip something, we can do this
			-- ImageRectOffset = function()
			-- 	return Vector2.new(px(711), 0)
			-- end,
			-- ImageRectSize = function()
			-- 	return Vector2.new(-px(711), px(176))
			-- end,
			padding {
				x = padding_types.px36,
				y = padding_types.px16,
			},
			create "UIScale" {
				Scale = scaleanim,
			},
		},
		padding {
			x = padding_types.px36,
			y = padding_types.px4,
		},
		pane {
			color = Color3.fromRGB(255, 0, 0),
			size = function()
				return UDim2.fromScale(0.9, 0.8)
			end,
			anchor = Vector2.new(0.5, 0.5),
			pos = UDim2.fromScale(0.5, 0.5),
			rotation = props.rotation,
			create "UIScale" {
				Scale = default_scale,
			},

			par {
				text = function()
					return text_sizes.bolded(read(props.text))
				end,
				color = textcolor,
				size = function()
					return px(text_sizes.heading.h3)
				end,
				wrap = true,
				xalign = Enum.TextXAlignment.Center,
			},
		},
	}
end

return ChoiceBubble
