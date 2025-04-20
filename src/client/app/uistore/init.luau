local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local types = require(ReplicatedStorage.types)
local display_types = require(ReplicatedStorage.types.display_types)
type Entity = types.Entity
type source<T> = vide.Source<T>
local source = vide.source

--[[
	TODO: Cleanup the file
]]

local sources = {
	-- By default, the player is not initially working. When a player is not working and they
	-- open their phone, we want to show an option to start working
	-- The server most likely will update this as well

	CashCurrency = source(0),
	GemsCurrency = source(0),

	IsWorking = source(false),
	ShowPhone = source(false),
	MyModel = source(workspace:FindFirstChild("Maeriil") :: Model),

	page = source("HudScreen" :: types.GamePages) :: source<types.GamePages>,
	lastpage = source("HudScreen" :: types.GamePages) :: source<types.GamePages>,

	-- Dialogue related sources
	DialogueAuthor = source(""),
	DialogueResponse = source(""),
	-- idk if we need responseid
	DialogueResponseId = source((0 :: unknown) :: Entity),
	DialogueChoices = source({} :: {
		{
			id: Entity,
			text: string,
		}
	}),

	NPCToAttachDialogues = source({} :: { Model }),
	IsTalkingWithNPC = source(false),
	DeliveryOrderList = source({} :: { [string]: types.DeliveryOrderType }),
	MyDialogueId = source(nil) :: types.Source<types.ActiveProximity?>,

	--[[
		For all proximity in the game, we only want to render it when it is close to the player
		When they are X studs away, it is instead replaced by billboard GUI with icon that tells user that
		something nearby is interactable. When a user goes even far away, nothing shows up
	]]

	DoorProximity = source({} :: { types.DoorProximityDetails }),
	MailboxProximity = source({} :: { types.MailboxProximityDetails }),
	ItemProximity = source({} :: { types.ItemProximityDetails }),
	-- For all of our actions, we can create a source like so
	-- InvestigateProximity = source({}),
	DialogueProximity = source({} :: { types.DialogueProximityDetails }),

	-- Active proximity is generic, so it will show every kind,
	-- We also need to make it so that... we provide "left" or "right" side
	ActiveProximity = source() :: types.Source<types.ActiveProximity?>,
	ActiveDialogueProximity = source() :: types.Source<types.ActiveProximity?>,
	ActiveDialgoueModel = source(nil) :: types.Source<Model?>,

	MyBackpack = source({}) :: types.Source<{ [types.Entity]: types.BackpackItemType }>,

	MyRating = source(0),
	ActiveOrder = source(nil) :: types.Source<types.Entity?>,

	poses_that_i_like = source({} :: { types.rouber_pose_category_t }),
	poses_that_i_dislike = source({} :: { types.rouber_pose_category_t }),
	pose_list = source({
		"default_deliver_pose",
		-- "deliver_elegantly",
	} :: { types.rouber_pose_t }),
	hint_description = source(
		`JohnDoe likes <font color="#00A2FF">flashy poses</font> but he hates poses with <font color="#FF0000">props!</font>`
	),

	backpack = source({} :: types.Array<types.Entity>),
	backpack_furnishings = source({} :: types.Array<display_types.BackpackFurnishings>),
	backpack_poses = source({} :: types.Array<display_types.BackpackPoses>),
}

return sources
