local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function play_cutscene()
	for i, props in world:query(c.Cutscene):iter() do
		if not props.is_scene_complete then
			continue
		end

		props.is_scene_complete = false
		local total_scenes = #props.cutscene
		props.curr_scene_id += 1

		warn(`====================`)
		warn(`Starting new scene! Next scene id is {props.curr_scene_id}`)

		if props.curr_scene_id > total_scenes then
			--TODO EXIT THE CUTSCENE, WE NEED TO RESET EVERYTHING THEN DELETE IT?
			warn(`We need to delete the cutscene now. Including resetting some stuff`)
			world:delete(i)
			continue
		end

		local scene = props.cutscene[props.curr_scene_id]
		for _, action in scene do
			world:add(action, c.StartAnimation)
		end

		-- Spawn whatever actions here and set each action to Uncompleted
	end
end

local function on_all_action_complete()
	local found_actions_in_progress = false
	for _ in world:query(c.CutsceneAction):iter() do
		found_actions_in_progress = true
	end

	if found_actions_in_progress then
		return
	end

	for i, props in world:query(c.Cutscene):iter() do
		props.is_scene_complete = true
	end
end

local all_tweens = world:query(c.Tween, c.TweenStatus):with(c.CutsceneAction):cached()
local animation_future_query = world:query(c.AnimationFuture):with(c.CutsceneAction):cached()
local walk_future = world:query(c.WalkToFuture):with(c.CutsceneAction):cached()
local sound_future = world:query(c.SoundFuture):with(c.CutsceneAction):cached()

local function poll_action()
	for i, tween, status in all_tweens:iter() do
		if
			tween.PlaybackState == Enum.PlaybackState.Completed
			or tween.PlaybackState == Enum.PlaybackState.Cancelled
		then
			print(">>>>>>>> TWEEN HAS COMPLETED!!")
			tween:Destroy()
			world:delete(i)
		end
	end

	for i, animationfuture in animation_future_query:iter() do
		local poll = animationfuture:poll()
		if not poll:isReady() then
			continue
		end

		local status = poll:unwrap()
		if status:isErr() then
			task.spawn(error, status:unwrapErr())
		end

		world:delete(i)
	end

	for i, walk_future in walk_future:iter() do
		local poll = walk_future:poll()
		if not poll:isReady() then
			continue
		end

		local status = poll:unwrap()
		if status:isErr() then
			task.spawn(error, status:unwrapErr())
		end

		print(`WALK TO FUTURE FINISHED!! with res {status:unwrapOk()}`)

		world:delete(i)
	end

	for i, walk_future in sound_future:iter() do
		local poll = walk_future:poll()
		if not poll:isReady() then
			continue
		end

		local status = poll:unwrap()
		if status:isErr() then
			task.spawn(error, status:unwrapErr())
		end

		world:delete(i)
	end
end

local function system()
	-- play_cutscene()
	-- poll_action()
	-- on_all_action_complete()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
