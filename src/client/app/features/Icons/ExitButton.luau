local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local baseicon = require(script.Parent.baseicon)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local px = use_px.px

type props = {
	inverted: boolean?,
	click: () -> (),
	disabled: types.Can<boolean>?,
	anchor: types.Can<Vector2>?,
	pos: types.Can<UDim2>?,
}

local function ExitButton(props: props)
	local image = if props.inverted
		then assets.images["ExitButtonInverted.svg"]
		else assets.images["ExitButton.svg"]

	return pane {
		zindex = 2,
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
	}
end

return ExitButton
