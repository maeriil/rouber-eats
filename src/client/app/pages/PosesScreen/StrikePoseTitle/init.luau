-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local hlayout           = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local scale             = require(ReplicatedStorage.client.app.components.scale.scale)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local next_order        = require(ReplicatedStorage.common.utility.next_order)

local px = use_px.px

type can<T> = T?
type letterprops = {
  rotation  : can<number>,
  text      : string,
  pos       : can<() -> UDim2>,
  order     : can<number>,
  scale     : can<number>,
  blurscale : can<number>,
}
type rootprops = {
  pos       : can<() -> UDim2>,
  anchor    : can<() -> Vector2>,
}
-- stylua: ignore end

local function letter(props: letterprops)
	local blur = assets.images["blur.png"]
	local stroke_color = function()
		return Color3.fromRGB(255, 255, 0)
	end
	local text_color = function()
		return Color3.fromRGB(255, 255, 150)
	end

	return pane {
		order = props.order,
		color = Color3.fromRGB(0, 255, 0),
		size = function()
			return UDim2.new(0, px(48), 0, px(96))
		end,
		pane {
			scale {
				scale = props.scale,
			},
			pos = props.pos,
			rotation = props.rotation,
			rtext {
				text = function()
					return `<stroke color="#{stroke_color():ToHex()}" transparency="0.45" thickness="{px(4)}">{props.text}</stroke>`
				end,
				bolded = true,
				italic = true,
				size = "lg",
				color = text_color,
				ttransparency = 0.34,
				baseimage {
					color = stroke_color,
					img = blur,
					scale {
						scale = props.blurscale or 1.25,
					},
				},
			},
		},
	}
end

local function title(props: rootprops)
	local order = next_order()
	return pane {
		color = Color3.fromRGB(),
		size = function()
			return UDim2.new(0, px(480), 0, px(240))
		end,
		pos = props.pos,
		anchor = props.anchor,
		pane {
			size = function()
				return UDim2.new(1, 0, 0.5, 0)
			end,
			hlayout {
				pad = padding_types.nopad,
			},
			pos = function()
				return UDim2.new(0, 0, 0.5, -px(32))
			end,
			anchor = function()
				return Vector2.new(0, 0.5)
			end,
			letter {
				text = "S",
				order = order(),
				rotation = -5,
				scale = 1.25,
			},
			letter {
				text = "t",
				order = order(),
				rotation = -25,
				scale = 0.95,
				pos = function()
					return UDim2.new(0, 0, 0, -px(20))
				end,
			},
			letter {
				text = "r",
				order = order(),
				rotation = -50,
				scale = 0.85,
				pos = function()
					return UDim2.new(0, -px(10), 0, -px(30))
				end,
			},
			letter {
				text = "i",
				order = order(),
				rotation = -33,
				scale = 0.75,
				pos = function()
					return UDim2.new(0, -px(20), 0, -px(15))
				end,
			},
			letter {
				text = "k",
				order = order(),
				rotation = -22,
				scale = 0.85,
				pos = function()
					return UDim2.new(0, -px(30), 0, -px(40))
				end,
			},
			letter {
				text = "e",
				order = order(),
				rotation = -5,
				scale = 0.65,
				pos = function()
					return UDim2.new(0, -px(40), 0, -px(15))
				end,
			},
		},
		pane {
			size = function()
				return UDim2.new(0.45, 0, 0.5, 0)
			end,
			hlayout {
				pad = padding_types.nopad,
				halign = Enum.HorizontalAlignment.Center,
			},
			pos = function()
				return UDim2.new(0.4, -px(48), 0.5, px(32))
			end,
			anchor = function()
				return Vector2.new(0.4, 0.5)
			end,
			rotation = -20,
			letter {
				text = "a",
				order = order(),
				rotation = -5,
				scale = 0.86,
			},
			letter {
				text = ".",
				order = order(),
				rotation = -5,
				scale = 0.93,
				blurscale = 0.25,
				pos = function()
					return UDim2.new(0, -px(10), 0, -px(15))
				end,
			},
			letter {
				text = ".",
				order = order(),
				rotation = -5,
				scale = 1,
				blurscale = 00.15,
				pos = function()
					return UDim2.new(0, -px(30), 0, -px(15))
				end,
			},
		},

		pane {
			size = function()
				return UDim2.new(0.65, 0, 0.5, 0)
			end,
			hlayout {
				pad = padding_types.nopad,
				halign = Enum.HorizontalAlignment.Center,
			},
			pos = function()
				return UDim2.new(1, -px(0), 0.5, px(0))
			end,
			anchor = function()
				return Vector2.new(1, 0.5)
			end,
			rotation = -20,
			letter {
				text = "P",
				order = order(),
				rotation = -0,
				scale = 1.1,
			},
			letter {
				text = "O",
				order = order(),
				rotation = 5,
				scale = 1.14,
				blurscale = 0.25,
				pos = function()
					return UDim2.new(0, px(10), 0, -px(15))
				end,
			},
			letter {
				text = "S",
				order = order(),
				rotation = 10,
				scale = 1,
				blurscale = 00.15,
				pos = function()
					return UDim2.new(0, px(15), 0, px(25))
				end,
			},
			letter {
				text = "e",
				order = order(),
				rotation = -5,
				scale = 1.22,
				blurscale = 00.15,
				pos = function()
					return UDim2.new(0, px(20), 0, -px(15))
				end,
			},
			letter {
				text = "!",
				order = order(),
				rotation = 5,
				scale = 1.4,
				blurscale = 00.15,
				pos = function()
					return UDim2.new(0, px(30), 0, -px(15))
				end,
			},
		},
	}
end

return title
