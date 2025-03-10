local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create

local function vibrant_red_gradient(props)
	local color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(230, 0, 0)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 50, 20)),
	}

	return create "UIGradient" {
		Color = color,
	}
end

return vibrant_red_gradient
