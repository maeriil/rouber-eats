local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create

local function square(props)
	return create "UIAspectRatioConstraint" {
		AspectRatio = 1.0,
		DominantAxis = Enum.DominantAxis.Height,
		AspectType = Enum.AspectType.ScaleWithParentSize,
	}
end

return square
