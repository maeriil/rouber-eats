local ReplicatedStorage = game:GetService("ReplicatedStorage")

local animations = require(ReplicatedStorage.assets.animations)
local c = require(ReplicatedStorage.common.ecs.components)
local config_types = require(ReplicatedStorage.types.config_types)
local world = require(ReplicatedStorage.common.ecs.world)

--[[

  This is our first basic animation, this will be improved much better later on. Right now
  we are also doing things that allows us to test out the features more. In this animation I want to
  ensure the following works
    - Camera animation: we need to animate it such that our camera is moving around while animation
    is being played
    - Lighting Effects: For the duration of the animation, sky/blur or other effects comes into play
    we can either manually tween/update it or add necessary components so that the systems take care of it
    - Sound effects: When we do the animations, we should have sounds synced to the animation.
    - Particle effects and any other enhancing effects on our characters avatar

  Either we do them directly here, or we delegate it to our existing systems.
]]
local animation = Instance.new("Animation")
animation.AnimationId = animations.DeliveringOrder

local function yieldable_run()
	local char, humanoid, hrp = world:exists_get(c.Client, c.Model, c.Humanoid, c.PrimaryPart)
	local animator = humanoid:FindFirstChildOfClass("Animator") :: Animator

	-- We should add some sound here, this is just the most basic delivery animation too

	local loaded_deliver_track = animator:LoadAnimation(animation)
	loaded_deliver_track.Looped = false
	loaded_deliver_track:Play()
	loaded_deliver_track.Ended:Wait()
	-- Once animation is done, we will reset all the effects and etc that we did

	loaded_deliver_track:Destroy()
end

local pose_details: config_types.rouber_pose_config_t = {
	name = "default_deliver_pose",
	rating = 1,
	display_name = `Default Deliver Food Pose`,
	category = "confident_pose",
	yieldable_run = yieldable_run,
	animation_id = animation,
	description = "some really long description about the animation that can span"
		.. "multiple lines so we would need to definitely support that"
		.. "and ensure it still looks legible and good for the UI",
}

return pose_details
