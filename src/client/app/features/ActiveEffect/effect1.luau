local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local assets = require(ReplicatedStorage.assets)
local interval = require(ReplicatedStorage.common.ecs.interval)
local types = require(ReplicatedStorage.types)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local vide = require(ReplicatedStorage.pkg.vide)

local cleanup = vide.cleanup
local source = vide.source
local create = vide.create

local function get_next(i: number, max: number)
	return if i == (max - 1) then 0 else i + 1
end

type props = {
	color: types.Can<Color3>?,
}

local function HoverEffect1(props: props)
	--[[
    time we found kinda nice so far
    0.04-0.06

  ]]
	local update_every = 0.04
	-- should directly use time tbh...
	local every = interval(update_every)
	local every_half = interval(update_every / 5)
	local max_sprites = 16
	local transparency, transparency_motion = use_motion(0)
	local index = source(0)
	local swap = source(false)

	cleanup(RunService.Heartbeat:Connect(function(a0: number)
		local has_half = every_half()
		local fulL_period = every()

		if has_half and not fulL_period then
			swap(true)
		end

		if fulL_period then
			index(get_next(index(), max_sprites))
			swap(false)
			transparency_motion:immediate(0)
			transparency_motion:tween(1, {
				direction = Enum.EasingDirection.Out,
				style = Enum.EasingStyle.Linear,
				time = update_every,
			})
		end
	end))

	return create "Frame" {
		-- BackgroundColor3 = Color3.fromRGB(),
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		create "ImageLabel" {
			Image = assets.images["HoverEffect1.svg"],
			ImageColor3 = props.color or Color3.fromRGB(255, 0, 0),
			ImageRectSize = Vector2.new(512, 128),
			ImageRectOffset = function()
				local curr = index()
				local x = if curr % 2 == 0 then 0 else 512
				local y = if curr == 0 then 0 else (math.floor(curr / 2) * 128)

				return Vector2.new(x, y)
			end,
			BackgroundTransparency = 1,
			ImageTransparency = transparency,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = function()
				-- return if not swap() then 2 else 1
				return 1
			end,
		},
		create "ImageLabel" {
			Image = assets.images["HoverEffect1.svg"],
			ImageColor3 = props.color or Color3.fromRGB(255, 0, 0),
			ImageRectSize = Vector2.new(512, 128),
			ImageRectOffset = function()
				local curr = get_next(index(), max_sprites)
				local x = if curr % 2 == 0 then 0 else 512
				local y = if curr == 0 then 0 else (math.floor(curr / 2) * 128)

				return Vector2.new(x, y)
			end,
			BackgroundTransparency = 1,
			ImageTransparency = function()
				return 0.5 - transparency()
			end,
			Size = UDim2.new(1, 0, 1, 0),
			ZIndex = function()
				-- return if swap() then 2 else 1
				return 2
			end,
		},
	}
end

return HoverEffect1
