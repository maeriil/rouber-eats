local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local colorscheme = require(ReplicatedStorage.client.store.colorscheme)

local px = use_px.px

type props = {
	[number]: any,
	text: () -> string,
	is_active: () -> boolean,
}

local function backpack_navbar(props: props)
	local image = assets.images["SidebarFrame.svg"]

	return pane {
		size = function()
			return UDim2.new(1, 0, 0, px(64))
		end,
		pane {
			anchor = Vector2.new(0.5, 0),
			pos = function()
				return UDim2.new(0.5, 0, 0, 0)
			end,
			size = function()
				return UDim2.new(1.2, 0, 1, 0)
			end,
			baseimage {
				img = image,
				color = function()
					return colorscheme.blood_red
				end,
			},
		},
		rtext {
			text = props.text,
			bolded = true,
			italic = false,
			wrap = true,
			size = "sm",
			color = function()
				return if props.is_active() then colorscheme.pure_black else colorscheme.warm_white
			end,
		},
		unpack(props),
	}
end

return backpack_navbar
