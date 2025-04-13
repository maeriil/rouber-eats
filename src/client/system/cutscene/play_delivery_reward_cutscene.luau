-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local tr = require(ReplicatedStorage.common.ecs.target)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

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

	task.wait(5)

	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Custom,
		fov = 70,
	})
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
