local ReplicatedStorage = game:GetService("ReplicatedStorage")
local future = require(ReplicatedStorage.pkg.future)
local jecs = require(ReplicatedStorage.pkg.jecs)
local queue = require(ReplicatedStorage.common.utility.queue)
local world = require(script.Parent.world)

local t = require(ReplicatedStorage.types)
type Poll<T = unknown> = future.Poll<T>

-- If components are almost always queried together, we should look to turn them into a table
-- Theres no point in introducing more fragmentation if they are alwyas together
local components = {
	Name = jecs.Name,
	Client = world:component() :: t.Entity<Player>,
	Model = world:component() :: t.Entity<Model>,
	BasePart = world:component() :: t.Entity<BasePart>,
	PrimaryPart = world:component() :: t.Entity<BasePart>,
	AgentParams = world:component() :: t.Entity<{
		radius: number,
		height: number,
		can_jump: boolean,
		can_climb: boolean,
		spacing: number,
	}>,
	PathCosts = world:component() :: t.Entity<{ [string]: number }>,
	Path = world:component() :: t.Entity<Path>,
	PathWaypoints = world:component() :: t.Entity<{ PathWaypoint }>,
	PathFuture = world:component() :: t.Entity<future.FutureLike<string, { PathWaypoint }>>,

	RayParams = world:component() :: t.Entity<RaycastParams>,
	OverParams = world:component() :: t.Entity<OverlapParams>,
	TweenParams = world:component() :: t.Entity<TweenInfo>,
	Tween = world:component() :: t.Entity<Tween>,

	Lifetime = world:component() :: t.Entity<number>,
	-- Typically should be used for component only I would say
	Cooldown = world:component() :: t.Entity<number>,

	Coins = world:component() :: t.Entity<number>,
	Gems = world:component() :: t.Entity<number>,

	Position = world:component() :: t.Entity<vector>,
	Transform = world:component() :: t.Entity<CFrame>,

	DeliveryOrderStatus = world:component() :: t.Entity<t.DeliveryOrderStatus>,
	DeliveryOrderDetails = world:component() :: t.Entity<{
		restaurant_name: string,
		audience_name: string,
		items: { string }, -- Food/Groceries/services too and etc?
		-- Right now only server can create orders, in future, players can too
	}>,

	-- Used like pair(WorkingAt, Order t.EntityId)
	WorkingAt = world:entity(),

	-- whether player is on job duty or on break
	-- Probably don't need this tbh if we are using WorkingAt
	IsWorking = world:entity(),

	EventRequest = world:entity() :: t.Entity<number>,
	Timestamp = world:component() :: t.Entity<number>,
	Start = world:entity(),
	End = world:entity(),
	Increase = world:entity(),
	Decrease = world:entity(),

	Assign = world:entity() :: t.Entity,
	Manager = world:entity() :: t.Entity,
	Dasher = world:entity() :: t.Entity,
	OffDuty = world:entity() :: t.Entity,
	Job = world:component() :: t.Entity<t.Entity>,

	OwnerOf = world:entity() :: t.Entity,
	OwnedBy = world:entity() :: t.Entity,
	Claim = world:entity() :: t.Entity,

	-- Residence is basically any place a player can claim as their own living space
	-- Player should be able to own multiple. They will start off with a basic apartment
	Residence = world:component() :: t.Entity<t.Entity>,
	House = world:entity() :: t.Entity,
	Apartment = world:entity() :: t.Entity,
	ApartmentUnit = world:entity() :: t.Entity,
	AptUnitOf = world:entity() :: t.Entity,
	Mansion = world:entity() :: t.Entity,

	TeleportZone = world:entity() :: t.Entity,
	DoormatZone = world:entity() :: t.Entity,
	Door = world:entity() :: t.Entity,
	Radius = world:component() :: t.Entity<number>, -- How close player has to be to open it
	CannotOpen = world:entity() :: t.Entity,
	CannotTeleport = world:entity() :: t.Entity,

	DoorStatus = world:component() :: t.Entity<boolean>,
	CastStatus = world:component() :: t.Entity<boolean>,
	TweenStatus = world:component() :: t.Entity<boolean>, -- True-> Start tween, false -> dont

	-- In future, player can own a restaurant too, not our problem right now though
	Restaurant = world:entity() :: t.Entity,

	TeleportTo = world:component() :: t.Entity<CFrame>,
	Connection = world:component() :: t.Entity<RBXScriptConnection>,

	EntityId = world:component() :: t.Entity<t.Entity>,
	Cleanup = world:component() :: t.Entity<() -> ()>,

	Interior = world:entity() :: t.Entity,
	Exterior = world:entity() :: t.Entity,

	-- Dialogue related stuff
	DialogueOf = world:entity() :: t.Entity,
	Choice = world:entity() :: t.Entity,
	FallbackChoice = world:entity() :: t.Entity,
	Dialogue = world:component() :: t.Entity<{
		author: string,
		conversation_distance: number,
		trigger_distance: number,
		initial_text: string,
	}>,
	DialogueDetails = world:component() :: t.Entity<{
		usertext: string | (() -> string),
		response: string | (() -> string),
	}>,
	DialogueId = world:component() :: t.Entity<string>,
	DialogueCondition = world:component() :: t.Entity<() -> boolean>,
	DialogueCallbacks = world:component() :: t.Entity<{ () -> () }>,
	GoTo = world:component() :: t.Entity<t.Entity>,
	ActiveDialogue = world:entity() :: t.Entity,
	PendingConditions = world:component() :: t.Entity<future.FutureLike<string, boolean>>,
	PendingChoices = world:component() :: t.Entity<queue.Queue<t.Entity>>,
	TerminateDialogue = world:entity() :: t.Entity,

	DoNotReconcile = world:entity() :: t.Entity,
	DoNotDelete = world:entity() :: t.Entity,

	NPC = world:entity() :: t.Entity,

	IsCutscenePlaying = world:entity() :: t.Entity,
}
do
	-- Because luau is ass
	local comp_to_iterate = (components :: unknown) :: { [string]: t.Entity | t.Entity<unknown> }
	for name, comp in comp_to_iterate do
		world:set(comp, jecs.Name, name)
	end
end

-- Remember to not delete any other components in OnRemove as that messes up with archetype moves
world:set(components.Connection, jecs.OnRemove, function(entity: t.Entity)
	local connection = world:get(entity, components.Connection)

	if connection then
		connection:Disconnect()
		connection = nil
	end
end)

world:set(components.Model, jecs.OnRemove, function(entity: t.Entity)
	local model = world:get(entity, components.Model)

	if model and not world:has(entity, components.DoNotDelete) then
		model:Destroy()
	end
end)

world:set(components.PrimaryPart, jecs.OnRemove, function(entity: t.Entity)
	local basepart = world:get(entity, components.PrimaryPart)

	if basepart and not world:has(entity, components.DoNotDelete) then
		basepart:Destroy()
	end
end)

world:set(components.BasePart, jecs.OnRemove, function(entity: t.Entity)
	local basepart = world:get(entity, components.BasePart)

	if basepart and not world:has(entity, components.DoNotDelete) then
		basepart:Destroy()
	end
end)

return components
