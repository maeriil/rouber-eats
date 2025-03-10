local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create

local function square(props)
	return create "UIAspectRatioConstraint" {
		AspectRatio = 1.0,
		DominantAxis = Enum.DominantAxis.Width,
	}
end

return square
