local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create

type props = {
	value: types.Can<number>,
}

local function ui_scale(props)
	return create "UIScale" {
		Scale = props.scale,
	}
end

return ui_scale
