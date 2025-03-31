local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basefont = require(ReplicatedStorage.common.configs.gamefont.basefont)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
--[[

  This is basically what we will display at the top right corner of the screen at all times
  basically whenever the HUD screen is present

  At this moment, we have two currency, I'll need to figure out some names for it to be honest
  and some icons for them as well... We just want to display how much they have right now and
  thats about it
]]

local create = vide.create
local read = vide.read
local px = use_px.px

local function format_number(n: number)
	if n >= 1_000_000_000 then
		return string.format("%.1f billion", n / 1_000_000_000)
	elseif n >= 1_000_000 then
		return string.format("%.1f million", n / 1_000_000)
	else
		local formatted = tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse()
		return formatted:gsub("^,", "")
	end
end

local function Text(props: {
	text: types.Can<number>,
	bolded: boolean?,
	italic: boolean?,
	textsize: types.Can<number>,
	color: Color3,
	stroke: {
		color: Color3,
		thickness: number,
		transparency: number,
	}?,
})
	local font = basefont.font

	return create "TextLabel" {
		RichText = true,
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		BackgroundTransparency = 1,
		Text = function()
			local text = `{format_number(read(props.text))}`
			if props.bolded then
				text = `<b>{text}</b>`
			end
			if props.italic then
				text = `<i>{text}</i>`
			end
			text = `<font family="{font.Family}" color="#{props.color:ToHex()}">{text}</font>`
			if props.stroke then
				local color = props.stroke.color
				local transparency = props.stroke.transparency
				local thickness = props.stroke.thickness

				text = `<stroke color="#{color:ToHex()}" thickness="{px(thickness)}" transparency="{px(
					transparency
				)}">{text}</stroke>`
			end

			return text
		end,
		TextSize = function()
			--//TODO: we want to have a central text sizes

			return px(read(props.textsize))
		end,
	}
end

local function Compartment(props: {
	order: types.Can<number>,
	value: types.Source<number>,
	size: types.Can<UDim2>,
	hscale: types.Can<number>,
	rotation: types.Can<number>,
	pos: types.Can<UDim2>,
	anchor: types.Can<Vector2>,
	[number]: any,
})
	return pane {
		size = props.size,
		pos = props.pos,
		anchor = props.anchor,
		create "ImageLabel" {
			Image = assets.images["SidebarFrame.svg"],
			Size = function()
				return UDim2.new(read(props.hscale) or 1, 0, 1, 0)
			end,
			ImageColor3 = Color3.fromRGB(),
			ImageTransparency = 0.15,
			AnchorPoint = Vector2.new(1, 0),
			Position = function()
				return UDim2.new(1, 0, 0, 0)
			end,
			Rotation = function()
				return props.rotation
			end,
			BackgroundTransparency = 1,
			pane {
				size = function()
					return UDim2.new(0.8, 0, 0.8, 0)
				end,
				pos = function()
					return UDim2.fromScale(0.5, 0.5)
				end,
				anchor = Vector2.new(0.5, 0.5),
				Text {
					text = function()
						return props.value()
					end,
					color = Color3.fromRGB(255, 255, 255),
					bolded = true,
					italic = true,
					textsize = function()
						return 48 * read(props.hscale)
					end,
				},
			},
		},
	}
end

type props = {
	curr1: types.Source<number>,
	curr2: types.Source<number>,
}

local function CurrencyHud(props: props)
	local order = next_order()

	return pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,

		Compartment {
			order = order(),
			value = props.curr2,
			size = function()
				return UDim2.new(1, 0, 0.4, 0)
			end,
			hscale = 0.75,
			rotation = 0,
			pos = function()
				return UDim2.new(0, 0, 1, -px(8))
			end,
			anchor = Vector2.new(0, 1),
		},
		Compartment {
			order = order(),
			value = props.curr1,
			size = function()
				return UDim2.new(1, 0, 0.6, 0)
			end,
			pos = UDim2.new(),
			anchor = Vector2.new(),
			hscale = 1,
			rotation = 4,
		},
	}
end

return CurrencyHud
