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

	page = source("HudScreen" :: types.GamePages) :: source<types.GamePages>,
	lastpage = source("HudScreen" :: types.GamePages) :: source<types.GamePages>,

	-- Dialogue related sources
	DialogueAuthor = source(""),
	DialogueResponse = source(""),
	DialogueResponseId = source((0 :: unknown) :: Entity),
	DialogueChoices = source({} :: {
		id: Entity,
		text: string,
	}),

	NPCToAttachDialogues = source({} :: { Model }),
	IsTalkingWithNPC = source(false),
	DeliveryOrderList = source({} :: { types.DeliveryOrderType }),

	--[[
		For all proximity in the game, we only want to render it when it is close to the player
		When they are X studs away, it is instead replaced by billboard GUI with icon that tells user that
		something nearby is interactable. When a user goes even far away, nothing shows up
	]]

	DoorProximity = source({} :: { types.DoorProximityDetails }),
	ActiveProximity = source() :: types.Source<types.ActiveProximity?>,

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

	]]
}

return sources
