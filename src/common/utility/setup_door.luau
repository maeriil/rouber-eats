local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local basepartmap = require(ReplicatedStorage.client.store.basepartmap)
local c = require(ReplicatedStorage.common.ecs.components)
local childof = require(script.Parent.childof)
local get_true_ancestor = require(script.Parent.get_true_ancestor)
local jecs = require(ReplicatedStorage.pkg.jecs)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local previous = require(script.Parent.previous)
local t = require(ReplicatedStorage.types)
local tags = require(ReplicatedStorage.types.tags)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

local function setup_doormatzone(doormat: Part, parent: t.Entity, params: OverlapParams)
	local e = world:entity()
	world:add(parent, pair(c.DoormatZone, e))
	world:add(e, c.DoormatZone)
	world:add(e, childof(parent))
	world:set(e, c.OverParams, params)
	world:set(e, c.CastStatus, false)
	world:set(e, c.BasePart, doormat)

	basepartmap[doormat] = e

	return e
end

local function setup_teleportzone(teleport: Part, parent: t.Entity, params: OverlapParams)
	local e = world:entity()
	world:add(parent, pair(c.TeleportZone, e))
	world:add(e, c.TeleportZone)
	world:add(e, childof(parent))
	world:set(e, c.OverParams, params)
	world:set(e, c.CastStatus, false)
	world:set(e, c.BasePart, teleport)

	basepartmap[teleport] = e

	return e
end

local function setup_door(door: Model, parent: t.Entity, open_cf_mul: CFrame)
	assert(door.PrimaryPart, `Primary part must exist for the door under the building {parent}`)

	local e = world:entity()
	world:add(parent, pair(c.Door, e))
	world:add(e, c.Door)
	world:add(e, childof(parent))
	world:set(e, c.Model, door)
	world:set(e, c.PrimaryPart, door.PrimaryPart)
	world:set(e, c.DoorStatus, false)
	world:set(e, c.TweenStatus, false)
	world:set(parent, c.DoorStatus, false)
	world:set(parent, previous(c.DoorStatus), false)

	local goal_time = 0.8
	local repeat_count = 0
	local reverses = false
	local delay_time = 0
	local params = TweenInfo.new(
		goal_time,
		Enum.EasingStyle.Bounce,
		Enum.EasingDirection.Out,
		repeat_count,
		reverses,
		delay_time
	)

	local door_hinge = door.PrimaryPart
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

	local doorcore = building:FindFirstChild("DoorCore") :: Model?
	assert(
		doorcore,
		`Doorcore does not exist for {building.Name} under {parentname}. Ensure that it exists`
	)

	--[[
		Each DoorCore must have at least 3 items
		1) DoorMat
		2) TeleportZone
		3) Door (Regular Door) or Left/Right (Sliding Door)

		If any one of them don't exist, we must throw an error
	]]
	local doormat = doorcore:FindFirstChild("DoorMat") :: Part?
	local teleport = doorcore:FindFirstChild("TeleportZone") :: Part?
	assert(
		doormat,
		`Doormat does not exist for {building.Name} under {parentname}. Ensure that it exists`
	)
	assert(
		teleport,
		`TeleportZone does not exist for {building.Name} under {parentname}. Ensure that it exists`
	)

	local doormatparams = OverlapParams.new()
	local teleportparams = OverlapParams.new()
	doormatparams:AddToFilter({ doormat, teleport } :: never)
	teleportparams:AddToFilter({ doormat, teleport } :: never)

	setup_doormatzone(doormat, building_id, doormatparams)
	setup_teleportzone(teleport, building_id, teleportparams)

	if doorcore:HasTag(tags.SlidingDoor) then
		local leftdoormodel = doorcore:FindFirstChild("Left") :: Model?
		local rightdoormodel = doorcore:FindFirstChild("Right") :: Model?
		assert(
			leftdoormodel,
			`Left does not exist for {building.Name} under {parentname}. Ensure that it exists`
		)
		assert(
			rightdoormodel,
			`Right does not exist for {building.Name} under {parentname}. Ensure that it exists`
		)

		setup_door(leftdoormodel, building_id, CFrame.new(vector.create(-4, 0, 0) :: never))
		setup_door(rightdoormodel, building_id, CFrame.new(vector.create(4, 0, 0) :: never))
	elseif doorcore:HasTag(tags.Door) then
		local doormodel = doorcore:FindFirstChild("Door") :: Model?
		assert(
			doormodel,
			`Door does not exist for {building.Name} under {parentname}. Ensure that it exists`
		)

		setup_door(doormodel, building_id, CFrame.Angles(0, math.rad(90), 0))
	else
		error(
			`Could not find a CollectionService Tag on Door for {building.Name} under {parentname}. File an issue`
		)
	end
end
