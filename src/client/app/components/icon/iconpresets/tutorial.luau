local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local icon = require(ReplicatedStorage.client.app.components.icon.icon)

type can<T> = T | () -> T
local function tutorial_icon(props: {
	color: can<Color3>?,
})
	local img = assets.images["tutorial.png"]
	return icon {
		img = img,
		color = props.color,
	}
end

return tutorial_icon
