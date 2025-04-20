local ReplicatedStorage = game:GetService("ReplicatedStorage")

local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local px = use_px.px

local function fallback(props)
	return frame {
		size = UDim2.new(1, 0, 1, 0),
		create "TextLabel" {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			TextSize = 96,
			Text = "Unkown page is shown",

			frame {
				size = function()
					return UDim2.new(0, px(200), 0, px(96))
				end,
				color = Color3.fromRGB(255, 0, 0),
				pos = function()
					return UDim2.new(0.5, 0, 1, -px(250))
				end,
				anchor = Vector2.new(0.5, 1),
				rtext {
					text = function()
						return `Go back`
					end,
					xbolded = true,
				},
				basebutton {
					click = go_back_page,
				},
			},
		},
	}
end

return fallback
