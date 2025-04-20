local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)

local px = use_px.px

type props = {
	[number]: any,
}

local function card_container(props)
	local basesize = Vector2.new(1280, 720)
	local size = function()
		return UDim2.new(0, px(basesize.X), 0, px(basesize.Y))
	end

	local image = assets.images["container_frame1.svg"]

	return pane {
		size = size,
		anchor = Vector2.new(0.5, 0.5),
		pos = UDim2.new(0.5, 0, 0.5, 0),
		baseimage {
			img = image,
		},
		unpack(props),
	}
end

return card_container
