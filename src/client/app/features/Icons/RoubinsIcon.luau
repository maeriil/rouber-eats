-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)

type can<T> = T?
type props = {
  color        : can<() -> Color3>,
  transparency : can<() -> number>,
}
-- stylua: ignore end

local function roubins_icon(props: props)
	local image = assets.images["IconPack1.svg"]
	local size = Vector2.new(256, 256)
	local rect_offset = Vector2.new(256 * 1, 256 * 2)

	return baseimage {
		img = image,
		anchor = function()
			return Vector2.new(0.5, 0.5)
		end,
		pos = function()
			return UDim2.fromScale(0.5, 0.5)
		end,
		color = props.color or function()
			return Color3.fromRGB(255, 255, 255)
		end,
		img_rect_offset = function()
			return rect_offset
		end,
		img_rect_size = function()
			return size
		end,
		transparency = props.transparency or function()
			return 0
		end,
	}
end

return roubins_icon
