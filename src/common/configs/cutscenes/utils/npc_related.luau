local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local future = require(ReplicatedStorage.pkg.future)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local function npc_walk_to(npc: Model, to: vector, walkspeed: number)
	local parent = ref(npc)
	local id = world:entity()

	local humanoid = world:get(parent, c.Humanoid)
	assert(humanoid, "Humanoid must exist for the npc entity")

	local walk = future.Future.new(function(...)
		humanoid.WalkSpeed = walkspeed
		humanoid:MoveTo(to :: never)
		local result = humanoid.MoveToFinished:Wait()
		return result
	end)

	world:add(id, c.CutsceneAction)
	world:set(id, c.WalkToFuture, walk)

	return id
end

local function npc_play_animation(npc: Model, animation_id: Animation, duration: number?)
	local parent = ref(npc)
	local id = world:entity()

	local animator = world:get(parent, c.Animator)
	assert(animator, "Animator must exist for the npc entity")

	local animation = future.Future.new(function(...)
		local track = animator:LoadAnimation(animation_id)
		local should_loop = duration ~= nil

		if should_loop then
			track.Looped = true
		end

		track:Play()

		if should_loop then
			task.wait(duration)
		else
			track.Stopped:Wait()
		end

		return true
	end)

	world:add(id, c.CutsceneAction)
	world:set(id, c.AnimationFuture, animation)

	return id
end

return {
	npc_walk_to = npc_walk_to,
	npc_play_animation = npc_play_animation,
}
