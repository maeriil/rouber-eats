local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local future = require(ReplicatedStorage.pkg.future)
local jecs = require(ReplicatedStorage.pkg.jecs)
local world = require(script.Parent.world)

local t = require(ReplicatedStorage.types)

-- If components are almost always queried together, we should look to turn them into a table
-- Theres no point in introducing more fragmentation if they are alwyas together
local components = {
	Name = jecs.Name,
	Client = world:component() :: t.Id<Player>,
	Model = world:component() :: t.Id<Model>,
	BasePart = world:component() :: t.Id<BasePart>,
	PrimaryPart = world:component() :: t.Id<BasePart>,
	Humanoid = world:component() :: t.Id<Humanoid>,
	-- Animator = world:component() :: t.Id<Animator>,
	-- AnimationTrack = world:component() :: t.Id<AnimationTrack>,

	AgentParams = world:component() :: t.Id<{
		radius: number,
		height: number,
		can_jump: boolean,
		can_climb: boolean,
		spacing: number,
	}>,
	PathCosts = world:component() :: t.Id<{ [string]: number }>,
	Path = world:component() :: t.Id<Path>,
	PathWaypoints = world:component() :: t.Id<{ PathWaypoint }>,
	PathFuture = world:component() :: t.Id<future.FutureLike<string, { PathWaypoint }>>,
	-- WalkToFuture = world:component() :: t.Id<future.FutureLike<string, boolean>>,
	BoolFuture = world:component() :: t.Id<future.FutureLike<string, boolean>>,

	--//TODO: merge the ray and over params together into a single {}
	RayParams = world:component() :: t.Id<RaycastParams>,
	OverParams = world:component() :: t.Id<OverlapParams>,
	TweenParams = world:component() :: t.Id<TweenInfo>,
	Tween = world:component() :: t.Id<Tween>,

	-- Generic tag, which can be used to start
	-- Tweens
	-- Animations using Animator
	-- Springs
	StartAnimation = world:entity() :: t.Entity,

	Lifetime = world:component() :: t.Id<number>,
	-- Typically should be used for component only I would say

	Roubins = world:component() :: t.Id<number>,
	Rating = world:component() :: t.Id<number>,

	--//TODO Do we even use Position?? If we don't remove it
	-- Apparently we use it on Pathfinding part, so i wont remove it just yet
	Position = world:component() :: t.Id<vector>,
	-- //TODO Do we even use Size?? If we don't remove it
	-- We apparently only use it to set Landplot, but we don't need to do that tbh
	-- Size = world:component() :: t.Id<vector>,

	Transform = world:component() :: t.Id<CFrame>,

	-- DeliveryOrderStatus = world:component() :: t.Id<t.DeliveryOrderStatus>,
	DeliveryOrderDetails = world:component() :: t.Id<t.DeliveryOrderDetailsComponentType>,
	HasOrderToBeDelivered = world:entity() :: t.Entity,
	ToDropOff = world:entity() :: t.Entity,
	ToAlter = world:entity() :: t.Entity,
	ToKeep = world:entity() :: t.Entity,
	HasMysteryBox = world:entity() :: t.Entity,

	-- Used like pair(WorkingAt, Order t.EntityId)
	WorkingAt = world:entity(),

	-- whether player is on job duty or on break
	-- Probably don't need this tbh if we are using WorkingAt?
	IsWorking = world:entity(),

	-- EventRequest = world:entity() :: t.Entity,
	Timestamp = world:component() :: t.Id<number>,
	Start = world:entity(),
	End = world:entity(),
	Increase = world:entity(),
	Decrease = world:entity(),

	--//TODO  we should expand upon this...
	Assign = world:entity() :: t.Entity,
	Manager = world:entity() :: t.Entity,
	Dasher = world:entity() :: t.Entity,
	OffDuty = world:entity() :: t.Entity,
	Job = world:component() :: t.Id<t.Entity | t.Id>,

	--//TODO: we might not need this
	-- OwnsBuilding = world:entity() :: t.Entity,
	-- OwnedBy = world:entity() :: t.Entity,

	--//TODO Deprecate the usage of OwnerOf, as its too generic. The entities are on thing that
	-- makes more sense that their aren't generic because they are super cheap to create
	OwnerOf = world:entity() :: t.Entity,
	Claimed = world:entity() :: t.Entity,
	ClaimedBy = world:entity() :: t.Entity,

	Vacant = world:entity() :: t.Entity,
	-- Residence is basically any place a player can claim as their own living space
	-- Player should be able to own multiple. They will start off with a basic apartment
	Residence = world:component() :: t.Id<t.Entity | t.Id>,
	House = world:component() :: t.Id<string>,

	--//TODO: Add apt only when we need it tbh, same for mansion
	-- Apartment = world:entity() :: t.Entity,
	-- ApartmentUnit = world:entity() :: t.Entity,
	-- AptUnitOf = world:entity() :: t.Entity,
	-- Mansion = world:entity() :: t.Entity,
	LandPlot = world:entity() :: t.Entity,

	--//TODO
	-- We could instead turn this into a single componet called OccupiedBy
	-- which contains two values, "npc" or "player", or it can contain entity Id too
	-- c.NPC, or c.Client
	OccupiedByPlayer = world:component() :: t.Id<t.Entity | t.Id>,
	OccupiedByNPC = world:component() :: t.Id<t.Entity | t.Id>,
	--//TODO: HouseOwner is redundant, we can use Occuped By directlyu
	HouseOwner = world:entity() :: t.Entity,

	--//TODO Not sure if we need teleport zone anymore?
	-- has some dependencies in pairs file but those can be changed im pretty sure...
	TeleportZone = world:entity() :: t.Entity,
	DoormatZone = world:entity() :: t.Entity,
	Mailbox = world:entity() :: t.Entity,
	Door = world:entity() :: t.Entity,
	Radius = world:component() :: t.Id<number>, -- How close player has to be to open it
	CannotOpen = world:entity() :: t.Entity,
	-- CannotTeleport = world:entity() :: t.Entity,

	--//TODO
	--TBH This could be a generic Status with <Status, Door>, <Status, Params>, <Status, Tween>
	DoorStatus = world:component() :: t.Id<boolean>,
	CastStatus = world:component() :: t.Id<boolean>,
	TweenStatus = world:component() :: t.Id<boolean>, -- True-> Start tween, false -> dont

	-- In future, player can own a restaurant too, not our problem right now though
	Restaurant = world:entity() :: t.Entity,
	Store = world:entity() :: t.Entity,

	TeleportTo = world:component() :: t.Id<CFrame>,
	--//TODO DO we use Connection somewhere?
	-- Connection = world:component() :: t.Id<RBXScriptConnection>,

	EntityId = world:component() :: t.Id<t.Entity | t.Id>,
	Cleanup = world:component() :: t.Id<() -> ()>,

	Interior = world:entity() :: t.Entity,
	Exterior = world:entity() :: t.Entity,

	-- Dialogue related stuff
	MyDialogue = world:component() :: t.Id<{
		id: t.Entity,
		current_position: t.Entity,
		system_completed: boolean,
		action_completed: boolean,
		dialogue_choice: t.Entity?,
	}>,
	HasDialogue = world:component() :: t.Id<{
		dialogue_id: string,
		conversation_distance: number,
		trigger_distance: number,
		initial_text: string,
	}>,
	DialogueChoice = world:entity() :: t.Entity,
	DialogueChoiceContainer = world:entity() :: t.Entity,
	DialogueResponse = world:entity() :: t.Entity,
	DialogueCallback = world:component() :: t.Id<() -> ()>,
	DialogueIf = world:component() :: t.Id<() -> boolean>,
	DialogueSuccess = world:entity() :: t.Entity,
	DialogueFailure = world:entity() :: t.Entity,
	DialogueGoto = world:entity() :: t.Entity,
	DialogueText = world:component() :: t.Id<string | (() -> string)>,
	DialogueKey = world:component() :: t.Id<string>,
	DialogueAuthor = world:component() :: t.Id<string>,
	Next = world:entity() :: t.Entity,

	DoNotReconcile = world:entity() :: t.Entity,
	DoNotDelete = world:entity() :: t.Entity,

	NPC = world:entity() :: t.Entity,
	-- House NPC are kind of NPC that must always have a residence
	-- If they dont have residence, then we must delete them and recycle
	HouseNPC = world:entity() :: t.Entity,

	HasCutscene = world:entity() :: t.Entity,
	IsCutscenePlaying = world:entity() :: t.Entity,
	Cutscene = world:component() :: t.Id<{
		triggered_id: t.Entity,
	}>,

	--//TODO: I dont think we need any of the below...
	-- AnimationFuture = world:component() :: t.Id<future.FutureLike<string, boolean>>,
	-- SoundFuture = world:component() :: t.Id<future.FutureLike<string, boolean>>,
	-- Sound = world:component() :: t.Id<Sound>,

	Camera = world:entity() :: t.Entity,
	CameraProperties = world:component() :: t.Id<{
		type: Enum.CameraType,
		fov: number,
	}>,

	-- Map should be entity tbh? And it contains Folder, so maybe folder component?
	-- Or i guess it can be component idk
	Parent = world:component() :: t.Id<t.Id | t.Entity>,
	Map = world:component() :: t.Id<Folder>,

	Interacted = world:entity() :: t.Entity,

	Food = world:entity() :: t.Entity,
	-- This is too generic ngl, too hard to understand if we are just directly using it...
	Value = world:component() :: t.Id<number>,
	Invalid = world:entity() :: t.Entity,

	Item = world:entity() :: t.Entity,
	-- Really we should only be using this on the server I think. On client, it might be better to spawn an entity? thoughts?
	Backpack = world:component() :: t.Id<{
		items: {
			[t.Entity]: {
				count: number,
			},
		},
		slot_kind: number,
	}>,
	BackpackItem = world:component() :: t.Id<t.Array<{
		item_id: t.Entity | t.Id,
		count: number,
	}>>,

	--// This is how the player would present their food
	PreferredPoseCategory = world:component() :: t.Id<{
		likes: { t.rouber_pose_category_t },
		dislikes: { t.rouber_pose_category_t },
	}>,
	Pose = world:component() :: t.Id<t.rouber_pose_t>,

	DeliveryCutscene = world:entity() :: t.Entity,
	DeliveryRewardCutscene = world:entity() :: t.Entity,
	Request = world:component() :: t.Id<() -> any>,
	-- Below are some of the UI event requests that we should fire to the server
	UpdateMyPreferences = world:entity(),
	Source = world:component() :: t.Id<(...any) -> ...any>,

	HotFoodCondition = world:entity(),
	DeliveryOrderCondition = world:entity(),
	Success = world:entity() :: t.Entity,
	Failure = world:entity() :: t.Entity,

	AcceptOrderPhase = world:entity() :: t.Entity,
	PickupOrderPhase = world:entity() :: t.Entity,
	DropOffOrderPhase = world:entity() :: t.Entity,
	CompleteOrderPhase = world:entity() :: t.Entity,

	Create = world:entity() :: t.Entity,
	Config = world:entity() :: t.Entity,

	-- UI Specific stuff
	UI_EVENT = world:entity() :: t.Entity,
	UIPage = world:component() :: t.Id<t.GamePages>,
	UI_update_orders_list = world:entity() :: t.Entity,
}

do
	-- Because luau is ass
	local comp_to_iterate = (components :: unknown) :: { [string]: t.Entity }
	for name, comp in comp_to_iterate do
		world:set(comp, jecs.Name, name)
	end
end

-- Remember to not delete any other components in OnRemove as that messes up with archetype moves
-- world:set(components.Connection, jecs.OnRemove, function(entity)
-- 	local connection = world:get(entity, components.Connection)

-- 	if connection then
-- 		connection:Disconnect()
-- 		connection = nil
-- 	end
-- end)

world:set(components.Model, jecs.OnRemove, function(entity)
	local model = world:get(entity, components.Model)
	if model and not world:has(entity, components.DoNotDelete) then
		model:Destroy()
	end
end)
world:add(components.Model, jecs.pair(jecs.OnDeleteTarget, jecs.Remove))

world:set(components.PrimaryPart, jecs.OnRemove, function(entity)
	local basepart = world:get(entity, components.PrimaryPart)

	if basepart and not world:has(entity, components.DoNotDelete) then
		basepart:Destroy()
	end
end)

world:set(components.BasePart, jecs.OnRemove, function(entity)
	local basepart = world:get(entity, components.BasePart)

	if basepart and not world:has(entity, components.DoNotDelete) then
		basepart:Destroy()
	end
end)

world:set(components.Cleanup, jecs.OnRemove, function(entity)
	local cleanup = world:get(entity, components.Cleanup)

	if cleanup and not world:has(entity, components.DoNotDelete) then
		cleanup()
	end
end)

world:add(components.Parent, jecs.pair(jecs.OnDeleteTarget, jecs.Remove))
world:add(components.Parent, jecs.pair(jecs.OnDeleteTarget, jecs.Delete))

do
	if RunService:IsStudio() or _G.__DEV__ then
		print(
			`Found {world.max_component_id} components in game with jecs.Component. Ensure that we aren't going over the limit set`
		)
		print(`The max component limit is {_G.__JECS_HI_COMPONENT_ID}`)
	end
end

return table.freeze(components)
