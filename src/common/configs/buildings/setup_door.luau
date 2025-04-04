local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local basepartmap = require(ReplicatedStorage.client.store.basepartmap)
local c = require(ReplicatedStorage.common.ecs.components)
local get_true_ancestor = require(ReplicatedStorage.common.utility.get_true_ancestor)
local jecs = require(ReplicatedStorage.pkg.jecs)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

--[[

	The general structure for the door is as follows

	Basic Door

	.../
		door/
			core/
				door_frame/
				frame
				handle
				hinge
			door_mat

	Sliding door or opening ish door

	../
		door/
			left/ and for right/
				door_frame/
				frame
				handle
				hinge
			door_mat

]]

--//TODO: idk if we need over params , verify tho before removing it
local function setup_doormatzone(doormat: Part, parent: t.Entity, params: OverlapParams)
	local e = world:entity() :: t.Entity
	world:add(parent, pair(c.DoormatZone, e))
	world:add(e, c.DoormatZone)
	world:add(e, pairs.childof(parent))
	world:set(e, c.OverParams, params)
	world:set(e, c.CastStatus, false)
	world:set(e, c.BasePart, doormat)
	basepartmap[doormat] = e

	return e
end

local function setup_door(door_hinge: Part, parent: t.Entity, open_cf_mul: CFrame)
	local e = world:entity()
	world:add(parent, pair(c.Door, e))
	world:add(e, c.Door)
	world:add(e, pairs.childof(parent))
	world:set(e, c.BasePart, door_hinge)
	world:set(e, c.DoorStatus, false)
	world:set(e, c.TweenStatus, false)
	world:set(parent, c.DoorStatus, false)
	world:set(parent, pairs.previous(c.DoorStatus), false)

	local goal_time = 0.8
	local repeat_count = 0
	local reverses = false
	local delay_time = 0
	local params = TweenInfo.new(
		goal_time,
		Enum.EasingStyle.Exponential,
		Enum.EasingDirection.Out,
		repeat_count,
		reverses,
		delay_time
	)

	local close_cf = door_hinge.CFrame
	local open_cf = door_hinge.CFrame * open_cf_mul

	local open_tween = TweenService:Create(door_hinge, params, {
		CFrame = open_cf,
	})
	local close_tween = TweenService:Create(door_hinge, params, {
		CFrame = close_cf,
	})

	world:set(e, pairs.TweenStart, open_tween)
	world:set(e, pairs.TweenEnd, close_tween)
	world:set(e, c.TweenParams, params)
end

return function(building: Model, building_id: t.Entity)
	local parent = get_true_ancestor(building)
	local parentname = parent.Name

	local door_folder = building:FindFirstChild("doors") :: Folder?
	assert(door_folder, `There must exist a folder named doors in the building {parentname}`)

	local doorcore = door_folder:FindFirstChild("door") :: Model?
	assert(
		doorcore,
		`door does not exist for {building.Name} under {parentname}. Ensure that it exists`
	)

	local doormat = doorcore:FindFirstChild("door_mat") :: Part?
	-- local teleport = doorcore:FindFirstChild("TeleportZone") :: Part?
	assert(
		doormat,
		`door_mat does not exist for {building.Name} under {parentname}. Ensure that it exists`
	)

	doormat.Transparency = 1

	local doormatparams = OverlapParams.new()
	doormatparams:AddToFilter({ doormat } :: never)
	setup_doormatzone(doormat, building_id, doormatparams)

	if doorcore:HasTag(tags.SlidingDoor) then
		error(`SLIDING DOOR IS NOT IMPLEMENTED YET!!!`)
		-- local leftdoormodel = doorcore:FindFirstChild("left") :: Model?
		-- local rightdoormodel = doorcore:FindFirstChild("right") :: Model?
		-- assert(
		-- 	leftdoormodel,
		-- 	`left  does not exist for {building.Name} under {parentname}. Ensure that it exists`
		-- )
		-- assert(
		-- 	rightdoormodel,
		-- 	`right  does not exist for {building.Name} under {parentname}. Ensure that it exists`
		-- )

		-- setup_door(leftdoormodel, building_id, CFrame.new(vector.create(-4, 0, 0) :: never))
		-- setup_door(rightdoormodel, building_id, CFrame.new(vector.create(4, 0, 0) :: never))
	elseif doorcore:HasTag(tags.Door) then
		local core = doorcore:FindFirstChild("core") :: Folder?
		assert(core ~= nil, `core folder/model must exist underneath door`)

		local hinge = core:FindFirstChild("hinge") :: Part?
		assert(hinge, `Hinge must exist for the door..`)

		setup_door(hinge, building_id, CFrame.Angles(0, math.rad(90), 0))
	elseif doorcore:HasTag(tags.DoubleDoor) then
		local left = doorcore:FindFirstChild("left") :: Folder?
		local right = doorcore:FindFirstChild("right") :: Folder?
		assert(
			left,
			`left  does not exist for {building.Name} under {parentname}. Ensure that it exists`
		)
		assert(
			right,
			`right does not exist for {building.Name} under {parentname}. Ensure that it exists`
		)

		local left_hinge = left:FindFirstChild("hinge") :: Part
		local right_hinge = right:FindFirstChild("hinge") :: Part

		setup_door(left_hinge, building_id, CFrame.Angles(0, math.rad(90), 0))
		setup_door(right_hinge, building_id, CFrame.Angles(0, -math.rad(90), 0))
	else
		error(
			`Could not find a CollectionService Tag on Door for {building.Name} under {parentname}. File an issue`
		)
	end
end
