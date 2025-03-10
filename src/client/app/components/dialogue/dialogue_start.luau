local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local basebutton = require(ReplicatedStorage.client.app.components.button.basebutton)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local icon = require(ReplicatedStorage.client.app.components.icon.icon)
local jecs = require(ReplicatedStorage.pkg.jecs)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local function dialogue_start(props: {
	pass: () -> (),
})
	return frame {
		color = Color3.fromRGB(0, 0, 255),
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		anchor = Vector2.new(0.5, 0.5),
		pos = UDim2.new(0.5, 0, 0.5, 0),
		square {},
		basebutton {
			click = function()
				print("clicked on the dialogue start frame")
				props.pass()
			end,
		},
		icon {
			img = assets.images["information.png"],
		},
	}
end

return dialogue_start
