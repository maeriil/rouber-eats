-- stylua: ignore start
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local assets = require(ReplicatedStorage.assets.assets)
local result_sources = require(ReplicatedStorage.client.app.features.Result.result_sources)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local graffiti = require(ReplicatedStorage.common.configs.gamefont.graffiti)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local tr = require(ReplicatedStorage.common.ecs.target)
local world = require(ReplicatedStorage.common.ecs.world)
local vide = require(ReplicatedStorage.pkg.vide)
local __ = jecs.Wildcard

local create = vide.create

local start_cutscene_query = world
  :query(c.Cutscene, c.Roubins, c.Rating) -- add conditions list too
  :with(c.Start, c.DeliveryRewardCutscene)
  :cached()
-- stylua: ignore end

local function play_reward_cutscene(
	cutscene_id: t.Entity,
	roubins_awarded: number,
	rating_awarded: number
)
	local my_humanoid, hrp = world:exists_get(c.Client, c.Humanoid, c.PrimaryPart)
	local camera = workspace.CurrentCamera

	warn(`>> Playing the reward cutscene now!`)
	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Scriptable,
		fov = 70,
	})

	local viewport = camera.ViewportSize

	-- Below code is copied from the use_px and converted to imperative style
	local scale = 1
	do
		local BASE_RESOLUTION = Vector2.new(1920, 1080)
		local MIN_SCALE = 0.35
		local DOMINANT_AXIS = 0.5
		local width = math.log(viewport.X / BASE_RESOLUTION.X, 2)
		local height = math.log(viewport.Y / BASE_RESOLUTION.Y, 2)
		local centered = width + (height - width) * DOMINANT_AXIS
		local final = math.max(math.pow(2, centered), MIN_SCALE)
		scale = final
	end
	local function px(value: number)
		return math.round(value * scale)
	end

	-- local me = Players.LocalPlayer
	-- local playergui = me:WaitForChild("PlayerGui") :: PlayerGui
	-- local screengui = Instance.new("ScreenGui")
	-- screengui.Name = "delivery_reward_cutscene_anim"
	-- screengui.Parent = playergui
	-- screengui.IgnoreGuiInset = true
	-- screengui.ResetOnSpawn = false
	-- screengui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	-- screengui.ScreenInsets = Enum.ScreenInsets.None
	-- screengui.Parent = playergui

	-- local parent_frame = Instance.new("Frame")
	-- parent_frame.Size = UDim2.new(1, 0, 1, 0)
	-- parent_frame.BackgroundTransparency = 1
	-- parent_frame.Parent = screengui

	-- local blur = Instance.new("ImageLabel")
	-- blur.ImageColor3 = Color3.fromRGB(255, 255, 255)
	-- blur.Size = UDim2.new(0.75, 0, 0.65, 0)
	-- blur.Position = UDim2.new(0.5, 0, 0.5, 0)
	-- blur.AnchorPoint = Vector2.new(0.5, 0.5)
	-- blur.Image = assets.images["blur.png"]
	-- blur.BackgroundTransparency = 1
	-- blur.ImageTransparency = 0.15
	-- blur.Parent = parent_frame

	-- local result_size = UDim2.new(0.85, 0, 0.5, 0)

	-- local result_text2 = Instance.new("TextLabel")
	-- result_text2.RichText = true
	-- result_text2.FontFace = graffiti.font
	-- result_text2.TextSize = px(graffiti.sizes.large)
	-- result_text2.Size = result_size
	-- result_text2.Rotation = -5
	-- result_text2.Text = `<b>Result Time!</b>`
	-- result_text2.TextColor3 = Color3.fromRGB(0, 150, 250)
	-- result_text2.TextScaled = true
	-- result_text2.Position = UDim2.new(0.5, -px(64), 0.5, -px(64))
	-- result_text2.AnchorPoint = Vector2.new(0.5, 0.5)
	-- result_text2.BackgroundTransparency = 1
	-- result_text2.Parent = parent_frame

	-- local result_text3 = Instance.new("TextLabel")
	-- result_text3.RichText = true
	-- result_text3.FontFace = graffiti.font
	-- result_text3.TextSize = px(graffiti.sizes.large)
	-- result_text3.Size = result_size
	-- result_text3.Rotation = -5
	-- result_text3.Text = `<b>Result Time!</b>`
	-- result_text3.TextColor3 = Color3.fromRGB(0, 150, 250)
	-- result_text3.TextScaled = true
	-- result_text3.Position = UDim2.new(1, px(64), 0.5, px(64))
	-- result_text3.AnchorPoint = Vector2.new(0.5, 0.5)
	-- result_text3.BackgroundTransparency = 1
	-- result_text3.Parent = parent_frame

	-- local result_text1 = Instance.new("TextLabel")
	-- result_text1.RichText = true
	-- result_text1.FontFace = graffiti.font
	-- result_text1.TextSize = px(graffiti.sizes.large)
	-- result_text1.Size = result_size
	-- result_text1.Rotation = -5
	-- result_text1.Text = `<b>Result Time!</b>`
	-- result_text1.TextColor3 = Color3.fromRGB(0, 150, 250)
	-- result_text1.TextScaled = true
	-- result_text1.Position = UDim2.new(0.5, 0, 0.5, 0)
	-- result_text1.AnchorPoint = Vector2.new(0.5, 0.5)
	-- result_text1.BackgroundTransparency = 1
	-- result_text1.Parent = parent_frame

	-- local res_tween_info =
	-- 	TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)

	-- local res2tween = TweenService:Create(result_text2, res_tween_info, {
	-- 	Position = UDim2.new(-1, -px(64), 0.2 - px(64)),
	-- 	TextTransparency = 1,
	-- })
	-- local res3tween = TweenService:Create(result_text3, res_tween_info, {
	-- 	Position = UDim2.new(1, px(64), 0.8, px(64)),
	-- 	TextTransparency = 1,
	-- })
	-- local blurtween = TweenService:Create(blur, res_tween_info, {
	-- 	ImageTransparency = 1,
	-- })

	-- res2tween:Play()
	-- res3tween:Play()
	-- blurtween:Play()
	-- task.wait(1)

	-- print("moving on..")

	print(`changing to reward screen..`)
	change_page("reward_screen")
	-- result_sources.start_result_animation(true)
	result_sources.start_animation_title(true)

	task.wait(2)

	result_sources.start_pose1(true)

	task.wait(5)

	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Custom,
		fov = 70,
	})
	-- screengui:Destroy()
	world:delete(cutscene_id)
end

local function system()
	-- There can only be one at a time
	local it = start_cutscene_query:iter()
	local cutscene_id, details, roubins_awarded, rating_awarded = it()
	if not cutscene_id then
		return
	end

	world:remove(cutscene_id, c.Start)
	task.spawn(play_reward_cutscene, cutscene_id :: t.Entity, roubins_awarded, rating_awarded)
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
