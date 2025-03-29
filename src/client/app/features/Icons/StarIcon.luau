local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local assets = require(ReplicatedStorage.assets)
local baseicon = require(script.Parent.baseicon)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local cleanup = vide.cleanup
local source = vide.source
local read = vide.read

type props = {
	nospin: types.Can<boolean>?,
	anchor: types.Can<Vector2>?,
	pos: types.Can<UDim2>?,
	size: types.Can<UDim2>?,
	color: types.Can<Color3>?,
}

local function StarIcon(props: props)
	local image = assets.images["ActiveStar.svg"]
	local rotation = source(0)
	local speed = 30

	cleanup(RunService.Heartbeat:Connect(function(dt: number)
		rotation((rotation() + dt * speed) % 360)
	end))

	return pane {
		size = props.size or function()
			return UDim2.new(0, math.max(px(71), 52), 0, math.max(px(71), 52))
		end,
		anchor = props.anchor,
		pos = props.pos,
		rotation = function()
			if read(props.nospin) then
				return 0
			end
			return rotation()
		end,
		baseicon {
			img = image,
			color = props.color or Color3.fromRGB(255, 255, 255),
		},
	}
end

return StarIcon
