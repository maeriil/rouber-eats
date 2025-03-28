local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

-- local start_npc_walk = world
-- 	:query(c.PrimaryPart, c.Animator, c.TweenParams, pairs.EndTransform)
-- 	:with(c.NPC, c.StartAnimation)
-- 	:without(c.Tween)
-- 	:cached()
-- local function start_the_npc_walk()
-- 	for i, part, animator, params, goal in start_npc_walk:iter() do
-- 		local tween = TweenService:Create(part, params, {
-- 			CFrame = goal,
-- 		})
-- 		local walk_animation = Instance.new("Animation")
-- 		walk_animation.AnimationId = "http://www.roblox.com/asset/?id=180426354"

-- 		local loaded_animation = animator:LoadAnimation(walk_animation)
-- 		loaded_animation:Play()
-- 		tween:Play()

-- 		world:set(i, c.AnimationTrack, loaded_animation)
-- 		world:set(i, c.Tween, tween)
-- 	end
-- end

local test_walk_npc =
	world:query(c.TweenParams, pairs.EndTransform):with(c.StartAnimation):without(c.Tween):cached()
local function test_walk_npc_system()
	for i, params, goal in test_walk_npc:iter() do
		local parent = world:parent(i)
		local primarypart = world:get(parent, c.PrimaryPart) :: Part
		local currpos = primarypart.Position
		primarypart.CFrame = CFrame.lookAt(currpos, goal.Position)

		local goals = { CFrame = goal }

		local tween = TweenService:Create(primarypart, params, goals)
		world:set(i, c.Tween, tween)
		world:set(i, c.TweenStatus, true)
		tween:Play()
		world:remove(i, c.StartAnimation)
	end
end

-- local npc_walk_ended = world:query(c.Tween, c.AnimationTrack):with(c.NPC):cached()
-- local function on_npc_walk_ended()
-- 	for i, tween, track in npc_walk_ended:iter() do
-- 		if
-- 			tween.PlaybackState == Enum.PlaybackState.Completed
-- 			or tween.PlaybackState == Enum.PlaybackState.Cancelled
-- 		then
-- 			track:Stop()
-- 		end
-- 	end
-- end

local function system()
	test_walk_npc_system()
	-- start_the_npc_walk()
	-- on_npc_walk_ended()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
