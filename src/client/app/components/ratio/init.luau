local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create

type props = {
	ratio: can<number>,
}

local function ratio(props: props)
	return create "UIAspectRatioConstraint" {
		AspectRatio = props.ratio,
		DominantAxis = Enum.DominantAxis.Height,
	}
end

return ratio
