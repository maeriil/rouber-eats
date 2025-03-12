local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local read = vide.read
local px = use_px.px

type can<T> = types.Can<T>

type props = {
	width_s: can<number>?,
	width: can<number>?,
	height_s: can<number>?,
	height: can<number>?,
	x_s: can<number>?,
	x: can<number>?,
	y_s: can<number>?,
	y: can<number>?,
	anchor_x: can<number>?,
	anchor_y: can<number>?,
	clips: can<boolean>?,
	order: can<number>?,
	name: can<number>?,
}

local function panel(props: props)
	local width_s = props.width_s or 0
	local height_s = props.height_s or 0
	local width = props.width or 0
	local height = props.height or 0
	local x = props.x or 0
	local y = props.y or 0
	local x_s = props.x_s or 0
	local y_s = props.y_s or 0
	local anchor_x = props.anchor_x or 0
	local anchor_y = props.anchor_y or 0

	return create "Frame" {
		Size = function()
			return UDim2.new(read(width_s), px(read(width)), read(height_s), px(read(height)))
		end,
		Position = function()
			return UDim2.new(read(x_s), px(read(x)), read(y_s), px(read(y)))
		end,
		AnchorPoint = function()
			return Vector2.new(read(anchor_x), read(anchor_y))
		end,

		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ClipsDescendants = props.clips,
		LayoutOrder = props.order,
		Name = props.name,
		unpack(props),
	}
end

return panel
