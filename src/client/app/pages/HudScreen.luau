local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CurrencyHUD = require(ReplicatedStorage.client.app.features.Currency.CurrencyHUD)
local PhoneIconButton = require(ReplicatedStorage.client.app.features.Icons.PhoneIconButton)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local padding = require(ReplicatedStorage.client.app.components.padding)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)

local px = use_px.px

local function HudScreen(props)
	return pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		padding {
			x = padding_types.px48,
			y = padding_types.nopad,
		},

		pane {
			size = function()
				return UDim2.new(0, px(400), 0, px(150))
			end,
			color = Color3.fromRGB(255, 0, 0),
			anchor = Vector2.new(1, 0),
			pos = function()
				return UDim2.new(1, 0, 0, 0)
			end,
			CurrencyHUD {
				curr1 = uistore.CashCurrency,
				curr2 = uistore.GemsCurrency,
			},
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
