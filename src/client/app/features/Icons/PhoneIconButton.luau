local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarIcon = require(script.Parent.StarIcon)
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local baseicon = require(script.Parent.baseicon)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local px = use_px.px

type props = {
	click: () -> (),
	disabled: types.Can<boolean>?,
	anchor: types.Can<Vector2>?,
	pos: types.Can<UDim2>?,
}

local function PhoneIconButton(props: props)
	local image = assets.images["PhoneIconFrame.svg"]
	return pane {
		size = function()
			return UDim2.new(0, math.max(px(71), 52), 0, math.max(px(71), 52))
		end,
		anchor = props.anchor,
		pos = props.pos,
		baseicon {
			img = image,
		},
		basebutton {
			click = props.click,
			disabled = props.disabled,
		},
		StarIcon {
			anchor = function()
				return Vector2.new(0.85, 0.25)
			end,
			pos = function()
				return UDim2.new(0.85, 0, 0.25, 0)
			end,
			size = function()
				return UDim2.new(0, math.min(32, px(48)), 0, math.max(32, px(48)))
			end,
			-- nospin = true,
		},
	}
end

return PhoneIconButton
