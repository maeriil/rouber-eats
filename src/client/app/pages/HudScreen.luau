local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PhoneIconButton = require(ReplicatedStorage.client.app.features.Icons.PhoneIconButton)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)

local function HudScreen(props)
	return pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		padding {
			padding = padding_types.px48,
		},
		PhoneIconButton {
			click = function()
				change_page("PhoneScreen")
			end,
			disabled = false,
			pos = function()
				return UDim2.new(1, 0, 0.5, 0)
			end,
			anchor = function()
				return Vector2.new(1, 0.5)
			end,
		},
	}
end

return HudScreen
