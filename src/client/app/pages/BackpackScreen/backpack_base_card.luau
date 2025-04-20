local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local scale = require(ReplicatedStorage.client.app.components.scale.scale)

type props = {
	[number]: any,
	color: Color3?,
}

local function backpack_base_card(props: props)
	local anchor_center = function()
		return Vector2.new(0.5, 0.5)
	end
	local pos_center = function()
		return UDim2.new(0.5, 0, 0.5, 0)
	end

	local foreground = props.color or Color3.fromRGB(255, 255, 255)

	return frame {
		scale {
			scale = 0.65,
		},
		rotation = 45,
		square {},
		pos = pos_center,
		anchor = anchor_center,
		color = Color3.fromRGB(),
		frame {
			size = function()
				return UDim2.new(0.95, 0, 0.95, 0)
			end,
			rotation = 0,
			square {},
			color = foreground,
		},
	}
end

return backpack_base_card
