local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local scale = require(ReplicatedStorage.client.app.components.scale.scale)
local transform_udim2 = require(ReplicatedStorage.client.app.utility.transform_udim2)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
--[[

  containers are fixed size, anchored to center of the screen.
  Then, we scale it up/down left/right depending on the aspect ratio and etc

]]

local read = vide.read
local px = use_px.px
local create = vide.create

type props = {
	size: types.Can<UDim2>,
	cardx_size: types.Can<number>,
	sidebar_size: types.Can<number>,
	exit: () -> (),
}

local function exitbutton(props: {
	click: () -> (),
})
	return frame {
		size = function()
			return UDim2.new(0, px(64), 0, px(64))
		end,
		pos = function()
			return UDim2.new(1, 0, 0, 0)
		end,
		anchor = Vector2.new(0.5, 0.5),
		basebutton {
			click = props.click,
		},
	}
end

local function actual_content(props: props)
	local order = next_order()

	return {

		exitbutton {
			click = props.exit,
		},
		frame {
			size = function()
				return UDim2.new(0, read(props.sidebar_size), 0, read(props.size).Y.Offset)
			end,
			anchor = Vector2.new(0.5, 1),
			pos = UDim2.new(0, 0, 1, 0),
			transparency = 0.5,
		},
		frame {
			size = props.size,
			anchor = Vector2.new(0.5, 1),
			pos = UDim2.fromScale(0.5, 1),
			transparency = 0,

			hlayout {
				pad = padding_types.nopad,
			},
			frame {
				order = order(),
				size = function()
					return UDim2.new(0, read(props.cardx_size), 1, 0)
				end,
				create "ImageLabel" {
					Size = function()
						--//TODO: what the fuck are these numbers... do something about it...
						-- Figure out how much we are scaling down from origina
						return UDim2.new(0, px(730 / 1.6), 0, px(1142 / 1.6))
					end,
					Position = function()
						return UDim2.new(0, -px(24), 0, -px(36))
					end,
					BackgroundTransparency = 1,
					Image = assets.images["CardEffect_test.svg"],

					frame {
						size = function()
							return UDim2.new(0, px(530 / 1.6), 0, px(850 / 1.6))
						end,
						transparency = 0.5,
						color = Color3.fromRGB(255, 255, 0),
						rotation = -4,
						anchor = Vector2.new(0.5, 1),
						pos = UDim2.new(0.5, 0, 1, -px(39 / 1.6 + 36 / 1.6)),
					},
				},
				zindex = 2,
			},
			frame {
				size = UDim2.new(1, 0, 1, 0),
				flexfill {},
				order = order(),
				padding {
					padding = padding_types.px16,
				},
				pane {
					size = function()
						return UDim2.new(1, 0, 1, 0)
					end,
				},
			},
		},
	} :: { any }
end

-- type sidebarprops = {
-- 	sizex: types.Can<number>,
-- }

local function container(props: props)
	local parent_size = function()
		return transform_udim2(read(props.size), { x = 1.05, y = 1.02 })
	end

	return pane {
		size = parent_size,
		anchor = Vector2.new(0.5, 0.5),
		pos = UDim2.fromScale(0.5, 0.5),

		--[[
			TODO
				Decoration
				Rotated stuff does not work ClipsDescendants, so we must use our own rotated image
				Might need to do some math to get it right, but thats not too important on my bucket list atm
				for now, I will simply add a bigger frame and set its size to red coloured.
				See the figma models for what the final design is supposed to look like
				We actually cant use Clips Descaendants cuz we need to let our sidebar overflow as well
		]]

		frame {
			size = UDim2.fromScale(1, 1),
			color = Color3.fromRGB(255, 0, 0),
		},

		actual_content {
			size = props.size,
			cardx_size = props.cardx_size,
			sidebar_size = props.sidebar_size,
			exit = props.exit,
		},
	}
end

return container
