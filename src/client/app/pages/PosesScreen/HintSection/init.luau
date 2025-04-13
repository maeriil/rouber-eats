local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local slight_rounded = require(ReplicatedStorage.client.app.components.corner.slight_rounded)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local next_order = require(ReplicatedStorage.common.utility.next_order)

local px = use_px.px

local function hint_title(props: {
	order: number,
})
	local stroke_color = Color3.fromRGB(200, 200, 200)

	return pane {
		color = Color3.fromRGB(0, 255, 0),
		order = props.order,
		size = function()
			return UDim2.new(0, px(156), 0, px(64))
		end,
		frame {
			size = function()
				return UDim2.new(0.9, 0, 0.5, 0)
			end,
			anchor = Vector2.new(0.5, 0.5),
			pos = function()
				return UDim2.new(0.5, 0, 0.5, 0)
			end,
			slight_rounded {},
		},
		rtext {
			text = function()
				return `<stroke color="#{stroke_color:ToHex()}" joins="miter" thickness="{px(4)}" transparency="0">Hint!</stroke>`
			end,
			wrap = true,
			italic = true,
			size = "md",
			color = function()
				return Color3.fromRGB(60, 60, 60)
			end,
		},
	}
end

local function hint_content(props: {
	text: () -> string,
	order: number,
})
	return pane {
		unpack(props),
		order = props.order,
		rtext {
			text = props.text,
			wrap = true,
			yalign = Enum.TextYAlignment.Top,
			xbolded = true,
		},
	}
end

type can<T> = T?
type props = {
	hint: () -> string,
	pos: can<() -> UDim2>,
	anchor: can<() -> Vector2>,
}

local function hint_section(props: props)
	local blur_effect = assets.images["blur.png"]
	local order = next_order()

	return pane {
		rotation = -4,
		color = Color3.fromRGB(255, 0, 255),
		pos = props.pos,
		anchor = props.anchor,
		size = function()
			return UDim2.new(0, px(460), 0, px(200))
		end,
		pane {
			anchor = Vector2.new(0.5, 0.5),
			pos = function()
				return UDim2.new(0.5, 0, 0.5, 0)
			end,
			size = function()
				return UDim2.new(2, 0, 2, 0)
			end,
			baseimage {
				color = function()
					return Color3.fromRGB(255, 255, 255)
				end,
				img = blur_effect,
				transparency = function()
					return 0.45
				end,
			},
		},
		pane {
			vlayout {
				halign = Enum.HorizontalAlignment.Left,
			},
			hint_title {
				order = order(),
			},
			hint_content {
				order = order(),
				text = props.hint,
				flexfill {},
			},
		},
		pane {
			size = function()
				return UDim2.new(1.5, 0, 1.5, 0)
			end,
			baseimage {
				color = function()
					return Color3.fromRGB(100, 100, 100)
				end,
				img = blur_effect,
				transparency = function()
					return 0.45
				end,
			},
		},
	}
end

return hint_section
