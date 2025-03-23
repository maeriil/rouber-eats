local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create
local read = vide.read

type props = {
	adornee: types.Can<BasePart>,
	max_distance: types.Can<number>?,
	size: types.Can<UDim2>?,
	active: types.Can<boolean>?,

	[number]: any,
}

-- I want everything in the game to have same distance billboard gui activation i think
-- unless it is super specific? idk
--! IMPORTANT: Billboard UI must be direct descendant of ScreenGui, it can be under a frame under ScreenGui
-- Another thing about our billboard UI is that we want it to be always fixed size

local function BillboardGui(props: props)
	-- By default we could make it so that each UI is like fixed size unless otherwise specified
	local max_distance = props.max_distance or 25

	return create "BillboardGui" {
		Size = props.size or UDim2.new(10, 0, 5, 0),
		Active = props.active or true,
		Adornee = props.adornee,
		AlwaysOnTop = true,
		-- Brightness = ???? TEST THIS OUT
		-- Configure this tbh
		-- DistanceLowerLimit = function()
		-- 	return math.huge
		-- end,
		-- -- DistanceStep  = function()
		-- -- 	return 1
		-- -- end,
		-- DistanceUpperLimit = function()
		-- 	return -1
		-- end,
		StudsOffsetWorldSpace = vector.create(0, 5, 0),
		MaxDistance = max_distance,
		-- ExtentsOffset = vector.create() -- the offset vector from our part relative to camera
		-- StudsOffset = vector.create() -- im ngl this feels same as above, we should figure out what diff it has
		-- ExtentsOffsetWorldSpace = vector.create(0, 10, 0),
		-- LightInfluence= 0
		-- SizeOffset = Vector2.new()-- apparently its like anchor point
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

		unpack(props),
	}
end

return BillboardGui
