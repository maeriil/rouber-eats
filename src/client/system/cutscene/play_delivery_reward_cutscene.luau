-- stylua: ignore start
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local assets = require(ReplicatedStorage.assets.assets)
local result_sources = require(ReplicatedStorage.client.app.features.Result.result_sources)
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
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

	print(`changing to reward screen..`)
	change_page("reward_screen")
	-- result_sources.start_result_animation(true)
	result_sources.animate_lines(true)
	task.wait(1)

	print("DONE, cleaning up!")

	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Custom,
		fov = 70,
	})
	-- screengui:Destroy()
	world:delete(cutscene_id)
	go_back_page()
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
