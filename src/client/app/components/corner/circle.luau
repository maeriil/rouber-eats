local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create

type props = {}

local function circle(props: props)
	return create "UICorner" {
		CornerRadius = UDim.new(1, 0),
	}
end

return circle
