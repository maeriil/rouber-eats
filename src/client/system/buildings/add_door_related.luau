local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local planck = require(ReplicatedStorage.pkg.planck)
local previous = require(ReplicatedStorage.common.utility.previous)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function create_door_entity(door: Model, doormat: Part, open_cf_mul: CFrame)
	local e = world:entity()
	local door_base = door.PrimaryPart
	assert(door_base ~= nil, "Primary part for the door must exist as this is the animating part")
	local overparams = OverlapParams.new()
	overparams:AddToFilter({ door, doormat } :: { any })

	world:add(e, c.Door)
	world:set(e, c.Model, door)
	world:set(e, c.DoorMat, doormat)
	world:set(e, c.PrimaryPart, door_base)
	world:set(e, c.OverParams, overparams)
	world:set(e, c.OpenStatus, "close")
	world:set(e, previous(c.OpenStatus), "close")

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

	local close_cf = door_base.CFrame
	local open_cf = door_base.CFrame * open_cf_mul

	local open_tween = TweenService:Create(door_base, params, {
		CFrame = open_cf,
	})
	local close_tween = TweenService:Create(door_base, params, {
		CFrame = close_cf,
	})

	world:set(e, pair(c.Tween, c.Start), open_tween)
	world:set(e, pair(c.Tween, c.End), close_tween)
	world:set(e, c.TweenParams, params)
end

local function basic_door()
	local instances = CollectionService:GetTagged("DoorRelated")
	for _, model in instances do
		assert(model:IsA("Model"))

		local doormat = model.PrimaryPart :: Part
		local door = model:FindFirstChild("Door") :: Model

		create_door_entity(door, doormat, CFrame.Angles(0, math.rad(90), 0))
	end
end

local function sliding_door()
	local instances = CollectionService:GetTagged("SlidingDoor")
	for _, model in instances do
		assert(model:IsA("Model"))

		local doormat = model.PrimaryPart :: Part
		local leftdoormodel = model:FindFirstChild("Left") :: Model
		local rightdoormodel = model:FindFirstChild("Right") :: Model

		create_door_entity(leftdoormodel, doormat, CFrame.new(vector.create(-4, 0, 0) :: any))
		create_door_entity(rightdoormodel, doormat, CFrame.new(vector.create(4, 0, 0) :: any))
	end
end

local function system()
	sliding_door()
	basic_door()
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {
		planck.runOnce(),
	},
}
