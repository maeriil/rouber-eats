local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create

type props = {}

local function slight_rounded(props: props)
	return create "UICorner" {
		CornerRadius = UDim.new(0.3, 0),
	}
end

return slight_rounded
