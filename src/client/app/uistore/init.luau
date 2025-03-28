local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity
type source<T> = vide.Source<T>
local source = vide.source

local sources = {
	-- By default, the player is not initially working. When a player is not working and they
	-- open their phone, we want to show an option to start working
	-- The server most likely will update this as well
	IsWorking = source(false),
	ShowPhone = source(false),
	MyModel = source(workspace:FindFirstChild("Maeriil")),

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
	-- For all of our actions, we can create a source like so
	-- InvestigateProximity = source({}),
	DialogueProximity = source({} :: { types.DialogueProximityDetails }),

	-- Active proximity is generic, so it will show every kind,
	-- We also need to make it so that... we provide "left" or "right" side
	ActiveProximity = source() :: types.Source<types.ActiveProximity?>,
	ActiveDialogueProximity = source() :: types.Source<types.ActiveProximity?>,
	ActiveDialgoueModel = source(nil) :: types.Source<Model?>,

	--[[

		Lets say we are near A, B, C, with closest to A, but near enough to B, and C.
		Suppose all of them are doors. How do we handle this?

	The ecs ensures that only one of them has showproximity=true
	the others will display the fallback icon proximity
			DoorProximityArray looks like
			{
				{adorne=a, exterior=..., text=..., showproximity=true}
				{adorne=a, exterior=..., text=..., showproximity=false}
				{adorne=a, exterior=..., text=..., showproximity=false}
			}

		ActiveProximity(entityid)

		We need to make it so that proximity is clickable, when clicked, we need to dispatch some
		action to ECS UI Event

		add_proximity_clicked (entityid: ActiveProximity())

			if not world:has(entityid, inCoolodnw(Interacted)) then
				world:add(entityid, Interacted)
			end

			system_that_listens_to_all_key_inputs () {

				grab_all_inputs ()
				query_for_entity_with_InProximityInteraction (only one must exist)

				if not world:has(entityId, inCooldown(Interacted)) then
				world:add(entityid, Interacted)
				end
			}

			query(Interacted):with(Door) {
				send_details_to_server()
				add_cooldown
			}

	algorithm for displaying proximity

	do raycast
	filter out all the valid ones only
	hold reference to part with min distance

	dialogue_function
		for all filtered part with dialogue entity
		if this part is ref part with min distance and its convo_distance is met
			mark this id as ActiveDialogueProximity

		Add the part's details to DialogueProximity, such as the initial message and other stuf
		that are needed for this function

	door_action_function
			for all filtered parts with door entity
				determine if we are entering or leaving
				add it to our proximity





	]]
}

return sources
