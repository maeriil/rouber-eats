local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)

local function text() end

local function container()
	local image = assets.images["ContainerTitlePack.svg"]
	local size = function()
		return Vector2.new(256, 320)
	end
	local rect_offset = function()
		return Vector2.new(256, 0)
	end
end

local function side_container(props: {
	flipped: boolean,
})
	local image = assets.images["ContainerTitlePack.svg"]
	local size = function()
		return Vector2.new(256, 320)
	end
	local rect_offset = function()
		return Vector2.new(0, 0)
	end
end

local function backpack_title(props) end

return backpack_title
