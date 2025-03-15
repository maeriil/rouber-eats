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
}

return sources
