local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create

local function light_gray_gradient(props)
	local color = ColorSequence.new {
		ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 190, 190)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
	}

	return create "UIGradient" {
		Color = color,
	}
end

return light_gray_gradient
