local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animations = require(ReplicatedStorage.assets.animations)
local jecs = require(ReplicatedStorage.pkg.jecs)
local soundasset = require(ReplicatedStorage.assets.soundasset)
local sounds = require(ReplicatedStorage.client.store.sounds)
local t = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local for_each_target = require(ReplicatedStorage.common.utility.for_each_target)
local freeze_player_movement = require(ReplicatedStorage.common.utility.freeze_player_movement)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

-- local function delivery_cutscene(trigger_id: t.Entity)
-- 	local exterior_house_id = world:parent(trigger_id)
-- 	local parent_house_id = world:get(exterior_house_id, c.Parent)
-- 	assert(parent_house_id, `Parent house id must exist`)

-- 	local house_model = world:get(exterior_house_id, c.Model)
-- 	local occurpied_by = world:get(parent_house_id, c.OccupiedByPlayer)

-- 	assert(house_model, "House model must exist")
-- 	assert(occurpied_by ~= nil, "Occupied by must exist ")
-- 	local owner_model = world:get(occurpied_by, c.Model)
-- 	assert(owner_model ~= nil, `There must be a model attached ot each house so we can animate..`)

-- 	local _humanoid, _hrp = world:get(c.Client, c.Humanoid, c.PrimaryPart)
-- 	local humanoid = _humanoid :: Humanoid
-- 	local animator = humanoid:FindFirstChildOfClass("Animator")
-- 	assert(animator ~= nil, `Animator instance must be child of Humanoid`)
-- 	local hrp = _hrp :: Part
-- 	freeze_player_movement.freeze()

-- 	local exterior_pos = world:get(exterior_house_id, c.Transform) :: CFrame
-- 	local global = sounds.global

-- 	-- humanoid.WalkSpeed = 0
-- 	task.spawn(function()
-- 		--[[
-- 			Camera change to scriptable and some side
-- 			Player moves all the way to the house teleport area
-- 			Play a sound that sounds like door bell ring
-- 			Open door
-- 			Owner model will show up
-- 			Do a little animation
-- 			Close Door
-- 			Cutscene complete
-- 		]]

-- 		world:set(c.Camera, c.CameraProperties, {
-- 			type = Enum.CameraType.Scriptable,
-- 			fov = 70,
-- 		})
-- 		local door_part = world:get(trigger_id, c.BasePart) :: Part
-- 		local door_pos = door_part.Position
-- 		local camera = workspace.CurrentCamera
-- 		local cutsceneparts_ro = workspace:FindFirstChild("CutsceneParts") :: Model?
-- 		assert(cutsceneparts_ro, `cutscene parts must be defined`)
-- 		local cutsceneparts = cutsceneparts_ro:Clone()
-- 		cutsceneparts.Parent = house_model
-- 		cutsceneparts:PivotTo(exterior_pos)

-- 		local cam_pos = (cutsceneparts:FindFirstChild("1") :: Part).CFrame
-- 		camera.CFrame = cam_pos

-- 		-- humanoid.WalkSpeed = 16
-- 		humanoid:MoveTo(door_pos)
-- 		humanoid.MoveToFinished:Wait()
-- 		task.wait(0.25)

-- 		cam_pos = (cutsceneparts:FindFirstChild("2") :: Part).CFrame
-- 		camera.CFrame = cam_pos

-- 		global.SoundId = soundasset.Doorbell
-- 		global.Looped = false
-- 		global:Play()
-- 		global.Ended:Wait()
-- 		warn(`Now we are animatign..`)
-- 		local temporary = owner_model:Clone()
-- 		temporary.Parent = house_model

-- 		-- local weld = Instance.new("WeldConstraint")
-- 		-- weld.Part0 = house_model.PrimaryPart
-- 		-- weld.Part1 = temporary.PrimaryPart
-- 		-- weld.Parent = temporary
-- 		local x = world:get(c.Client, c.Model)

-- 		-- We can instead make sure all the owner's pivot is set to the feet
-- 		temporary:PivotTo(
-- 			-- TODO, find a better way to do this...
-- 			house_model.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
-- 				+ vector.create(0, 1.5, 0)
-- 		)
-- 		world:set(exterior_house_id, c.DoorStatus, true)

-- 		local temp_humanoid = temporary:FindFirstChildOfClass("Humanoid")
-- 		assert(temp_humanoid, `Humanoid must exist for the owner model`)

-- 		local temp_animator = temp_humanoid:FindFirstChildOfClass("Animator")
-- 		assert(temp_animator, `Animator must exist for the owner model`)

-- 		for_each_target(exterior_house_id, c.Door, function(id)
-- 			world:set(id, c.DoorStatus, true)
-- 			world:set(id, c.TweenStatus, true)
-- 		end)

-- 		task.wait(0.25)
-- 		local deliver_animation = Instance.new("Animation")
-- 		deliver_animation.AnimationId = animations.DeliveringOrder

-- 		local dance_animation = Instance.new("Animation")
-- 		dance_animation.AnimationId = animations.Dance1

-- 		local clap_animation = Instance.new("Animation")
-- 		clap_animation.AnimationId = animations.Cheering1

-- 		local loaded_deliver_track = animator:LoadAnimation(deliver_animation)
-- 		loaded_deliver_track.Looped = false
-- 		loaded_deliver_track:Play()
-- 		local e = temp_animator:LoadAnimation(dance_animation)
-- 		e.Looped = true
-- 		e:Play()

-- 		loaded_deliver_track.Ended:Wait()
-- 		e:Stop()
-- 		e:Destroy()

-- 		e = temp_animator:LoadAnimation(clap_animation)
-- 		e.Looped = true
-- 		e:Play()

-- 		task.wait(2)
-- 		e:Stop()
-- 		e:Destroy()

-- 		task.wait(1)

-- 		for_each_target(exterior_house_id, c.Door, function(id)
-- 			world:set(id, c.DoorStatus, false)
-- 			world:set(id, c.TweenStatus, true)
-- 		end)
-- 		world:set(c.Camera, c.CameraProperties, {
-- 			type = Enum.CameraType.Custom,
-- 			fov = 70,
-- 		})

-- 		local next_walk_to_cf = hrp.CFrame * CFrame.new(0, 0, 25)
-- 		humanoid:MoveTo(next_walk_to_cf.Position)
-- 		humanoid.MoveToFinished:Wait()
-- 		task.wait(1)

-- 		temporary:Destroy()
-- 		cutsceneparts:Destroy()

-- 		freeze_player_movement.unfreeze()

-- 		world:remove(c.Client, c.IsCutscenePlaying)
-- 		world:remove(trigger_id, c.HasCutscene)
-- 	end)
-- end

local cached = world:query(c.Cutscene):with(c.IsCutscenePlaying, c.Start):cached()
local function system()
	local it = cached:iter()
	local e, config = it()
	if not e then
		return
	end

	warn(`EXECUTING THE CUTSCENE IN THE SYSTEM`)
	-- delivery_cutscene(config.triggered_id)

	-- We want to remove all the proximity related stuff
	uistore.DoorProximity({})
	uistore.DialogueProximity({})

	-- world:remove(c.Client, c.Start)
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
