--[[
	There needs to be multiple parts in the animation

	1. Going to the door and opening it
		1. Walk to the door
		2. Ring the door bell
		3. House owner come out and there is a question mark on their head (?)
	2. Select a pose UI shows up now
		1. Halt everything until we have selected poses for all deliveries on this house
		2. Note that there could be more than one
	3. Then there becomes a mini loop
		1. Go through each pose list
		2. Run the pose
		3. Animate the house owner face based on satisfactions rate
		4. Show that on the UI a bit, something like satisfaction rate
	4. Once everyting is done
		1. Close door
		2. Player walks away, and then the victory screen should show up now
]]
-- stylua: ignore start
local ReplicatedStorage           = game:GetService("ReplicatedStorage")
local animations                  = require(ReplicatedStorage.assets.animations)
local change_page                 = require(ReplicatedStorage.client.app.utility.change_page)
local freeze_player_movement      = require(ReplicatedStorage.common.utility.freeze_player_movement)
local jecs                        = require(ReplicatedStorage.pkg.jecs)
local phases                      = require(ReplicatedStorage.common.ecs.phases)
local soundasset                  = require(ReplicatedStorage.assets.soundasset)
local uistore                     = require(ReplicatedStorage.client.app.uistore)
local go_back_page                = require(ReplicatedStorage.client.app.utility.go_back_page)
local server_id_map               = require(ReplicatedStorage.client.store.server_id_map)
local sounds                      = require(ReplicatedStorage.client.store.sounds)
local emotes                      = require(ReplicatedStorage.common.configs.emotes)
local poses                       = require(ReplicatedStorage.common.configs.poses)

local all_targets                 = require(ReplicatedStorage.common.ecs.target)
local c                           = require(ReplicatedStorage.common.ecs.components)
local p                           = require(ReplicatedStorage.common.ecs.pairs)
local t                           = require(ReplicatedStorage.types)
local world                       = require(ReplicatedStorage.common.ecs.world)
local invoke_complete_order_event = require(ReplicatedStorage.common.events.order.invoke_complete_order_event)
local try_strike_order_pose_event = require(ReplicatedStorage.common.events.order.try_strike_order_pose_event)
local throw_error                 = require(ReplicatedStorage.common.utility.throw_error)
local pair                        = jecs.pair
local __                          = jecs.Wildcard


local start_cutscene_query = world
	:query(c.Cutscene)
	:with(c.IsCutscenePlaying, c.Start, c.DeliveryCutscene)
	:cached()

local end_cutscene_query = world
	:query(c.Cutscene)
	:with(c.IsCutscenePlaying, c.End, c.DeliveryCutscene)
	:cached()
-- stylua: ignore end

local function grab_house_and_owner_id(parent_house_id: t.Entity)
	local occupied_by, exterior_house_id =
		world:exists_get(parent_house_id, c.OccupiedByPlayer, p.EntityId(c.Exterior))

	return exterior_house_id, occupied_by
end

local function select_poses()
	--[[
		We need to do a loop, or some kind of signal/remote function functionality basicallyt
		From client side, there needs to be an array of order_id present for the house. OR
		we should just be able to loop through our to_deliver order_ids in client. We go through
		one by one and determine the pose for each until we have processed through all

		For each:
			Show the ui screen
			Await for user choice select
			Once the user selects, it will dispatch to event queue
			Do some sanity checks
			Send details to server
			Server will verify, and then send in 3 details. The pose to render, satisfaction pose, and status
			We can just choose to ignore status atm, and instead add to queue the pose to render
			And then it will go to the next pick

		Then once that is done we move on to renderin it.
		For each
			Index the pose by using the config file
			Run the yieldable function
			Wait until it completes
			Show the animation of customer satisfaction
			Show a UI showing what rating we got for this order
			And then it will go to the next pick

		Then, finally, we move on to the exit cutscene, which will be listed in end_cutscene basically
	]]
end

local my_orders_to_drop_off = world:query(c.DeliveryOrderDetails):with(c.ToDropOff):cached()
local function get_orders_to_drop_off(client_house_id: t.Entity)
	local server_id = world:exists_get(client_house_id, c.EntityId)
	local queue = {}

	for client_order_id, details in my_orders_to_drop_off:iter() do
		if details.destination_id == server_id then
			print("found an order to drop off!")
			table.insert(queue, client_order_id)
		end
	end

	return queue
end

local function start_cutscene(house_id: t.Entity, cutscene_id: t.Entity)
  -- stylua: ignore start
  local exterior_house_id, owner_id  = grab_house_and_owner_id(house_id)
  local camera                       = workspace.CurrentCamera
  local exterior_model, exterior_pos = world:exists_get(exterior_house_id, c.Model, c.Transform)
  local house_owner_model            = world:exists_get(owner_id, c.Model)
  local my_humanoid, hrp             = world:exists_get(c.Client, c.Humanoid, c.PrimaryPart)
  local door_id                      = world:target(exterior_house_id, c.DoormatZone) :: t.Entity
  local door_position                = world:exists_get(door_id, c.BasePart).Position
	-- stylua: ignore end

	house_owner_model.Parent = workspace.cutscene_render
	local humanoid = house_owner_model:FindFirstChildOfClass("Humanoid") :: Humanoid
	local animator = humanoid:FindFirstChildOfClass("Animator") :: Animator
	local sound = sounds.global

	freeze_player_movement.freeze()

	-- Find out what kind of cutscene to use depending on the exterior house model
	local cutsceneparts_ro = workspace:FindFirstChild("CutsceneParts") :: Model?
	assert(cutsceneparts_ro, `cutscene parts must be defined`)
	local cutsceneparts = cutsceneparts_ro:Clone()
	cutsceneparts.Parent = exterior_model
	cutsceneparts:PivotTo(exterior_pos)

	print("ok we ar edoing some animation..")

	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Scriptable,
		fov = 70,
	})

	-- Then we need to tween the camera from curr pos to the first specified pos in cutscene
	-- We should be using our already created camera tween system which will do the tween while
	-- we move our player model simulatenously
	local cam_pos = (cutsceneparts:FindFirstChild("1") :: Part).CFrame
	camera.CFrame = cam_pos

	-- Face the player so that they are few studs away from the doormatpos and facing it
	-- Then we are ready to move our player to walk to the door
	-- hrp.CFrame = CFrame.lookAt(door_position + vector.create(0, 0, 10) :: never, door_position)
	my_humanoid:MoveTo(door_position)
	my_humanoid.MoveToFinished:Wait()

	-- We shouldn't tween for this. Rather directly impulse to it
	cam_pos = (cutsceneparts:FindFirstChild("2") :: Part).CFrame
	camera.CFrame = cam_pos

	-- Prepare the house owner model and put them directly on the appropriate location
	local exterior_root_part = exterior_model.PrimaryPart :: Part
	local owner_render_cf = exterior_root_part.CFrame * CFrame.Angles(0, math.rad(180), 0)
		+ vector.create(0, 1.5, 0) :: never
	house_owner_model:PivotTo(owner_render_cf)

	-- Next, play the doorbell sound. Then the door should open
	sound.SoundId = soundasset.Doorbell
	sound.Looped = false
	sound:Play()
	sound.Ended:Wait()

	-- for_each_target(exterior_house_id, c.Door, function(id)
	-- 	world:set(id, c.DoorStatus, true)
	-- 	world:set(id, c.TweenStatus, true)
	-- end)
	for _, target_id in all_targets(exterior_house_id, c.Door) do
		world:set(target_id, c.DoorStatus, true)
		world:set(target_id, c.TweenStatus, true)
	end

	-- Move the house owner forward by like few studs now
	-- We might not even bother doing this if the cutscene is too long
	-- local house_owner_hrp = house_owner_model.PrimaryPart :: Part
	-- humanoid:MoveTo(house_owner_hrp.Position + vector.create(0, 0, 2) :: never)
	-- humanoid.MoveToFinished:Wait()

	--//TODO: render the question mark bubble on top of their head now. As well as animation
	-- They should also have a small sound when they play this animation
	local question_animation = Instance.new("Animation")
	question_animation.AnimationId = animations.Cheering1
	local loaded_track = animator:LoadAnimation(question_animation)
	loaded_track.Looped = false
	loaded_track:Play()
	loaded_track.Ended:Wait()

	-- Now the starting part of the animation is done, we should be showing the UI page
	-- Once the UI Page click is found, it needs to execute to a seperate run pose systems
	-- All the dynamically cloned stuff needs to be stored in some ref
	question_animation:Destroy()
	loaded_track:Destroy()
	world:set(cutscene_id, c.Model, cutsceneparts)

	local orders_to_process = get_orders_to_drop_off(house_id)
	for i = #orders_to_process, 1, -1 do
		local order_id = orders_to_process[i]
		uistore.ActiveOrder(order_id :: t.Entity)

		change_page("pose_screen")
		-- Halt this thread until we make a selection which will fire to server, then we will
		-- continue processing here
		warn(`Halting thread now...`)
		local status, pose_to_strike, emotion_to_play = try_strike_order_pose_event.from_server()

		if not status.success then
			throw_error(`Pose failed, {status.error_msg}`)
			-- what should we do in this case?
		end
		go_back_page()

		-- Play the pose now...
		local pose_details = poses[pose_to_strike :: never]
		pose_details.yieldable_run()

		local emotion_config = emotes[emotion_to_play :: never]
		local animation = emotion_config.animation
		local customer_emotion_track = animator:LoadAnimation(animation)
		customer_emotion_track.Looped = false
		customer_emotion_track:Play()
		customer_emotion_track.Ended:Wait()
		customer_emotion_track:Destroy()

		print("animation is done now, moving on to the next one...")

		orders_to_process[i] = nil
	end

	warn(`marking the cutscene as ended...`)
	world:add(cutscene_id, c.End)
end

local function end_cutscene(house_id: t.Entity, cutscene_id: t.Entity)
	-- The animation should end and cleanup with house owner waving goodbye and closing door after
  -- stylua: ignore start
  local exterior_house_id, owner_id  = grab_house_and_owner_id(house_id)
  local camera                       = workspace.CurrentCamera
  local exterior_model, exterior_pos = world:exists_get(exterior_house_id, c.Model, c.Transform)
  local house_owner_model            = world:exists_get(owner_id, c.Model)
  local my_humanoid, hrp             = world:exists_get(c.Client, c.Humanoid, c.PrimaryPart)
  local doormat_id                   = world:target(exterior_house_id, c.DoormatZone) :: t.Entity
	-- stylua: ignore end

	for _, target_id in all_targets(exterior_house_id, c.Door) do
		world:set(target_id, c.DoorStatus, false)
		world:set(target_id, c.TweenStatus, true)
	end

	local go_back = hrp.CFrame * CFrame.new(0, 0, 25)
	my_humanoid:MoveTo(go_back.Position)
	my_humanoid.MoveToFinished:Wait()

	world:set(c.Camera, c.CameraProperties, {
		type = Enum.CameraType.Custom,
		fov = 70,
	})

	-- Parent it back to the NPC folders
	house_owner_model.Parent = ReplicatedStorage
	freeze_player_movement.unfreeze()

	world:remove(c.Client, c.IsCutscenePlaying)
	world:remove(doormat_id, c.HasCutscene)
	world:delete(cutscene_id)

	-- Fire to the server mentioning that we have completed all the order poses for destination_id
	local server_house_id = world:exists_get(house_id, c.EntityId)
	invoke_complete_order_event.to_server(server_house_id :: t.Entity)
end

local function start_scene()
	-- Start Cutscene
	local it = start_cutscene_query:iter()
	local id, details = it()
	if not id then
		return
	end
	warn(`Starting the delivery cutscene!`)
	world:remove(id, c.Start)
	task.spawn(start_cutscene, details.triggered_id, id :: t.Entity)
end

local function end_scene()
	-- End Cutscene
	local it = end_cutscene_query:iter()
	local id, details = it()
	if not id then
		return
	end
	warn(`Ending the delivery cutscene!`)
	world:remove(id, c.End)
	task.spawn(end_cutscene, details.triggered_id, id :: t.Entity)
end

local function system()
	start_scene()
	end_scene()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
