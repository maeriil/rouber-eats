local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phone_pages = require(script.phone_pages)
local ui_pages = require(script.ui_pages)
local vide = require(ReplicatedStorage.pkg.vide)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity
type source<T> = vide.Source<T>
local source = vide.source

local _TESTNOOB = workspace:FindFirstChild("Noob") :: Model

local sources = {
	-- By default, the player is not initially working. When a player is not working and they
	-- open their phone, we want to show an option to start working
	-- The server most likely will update this as well
	IsWorking = source(false),
	ShowPhone = source(true),
	PhonePage = source(phone_pages.Resting :: phone_pages.PhonePages) :: vide.Source<phone_pages.PhonePages>,

	page = source(ui_pages.Game),
	lastpage = source(ui_pages.Game),

	-- Dialogue related sources
	DialogueAuthor = source(""),
	DialogueResponse = source(""),
	DialogueResponseId = source((0 :: unknown) :: Entity),
	DialogueChoices = source({} :: {
		id: Entity,
		text: string,
	}),

	NPCToAttachDialogues = source({ _TESTNOOB } :: { Model }),
	IsTalkingWithNPC = source(false),

	DeliveryOrderList = source({} :: { Entity }),
}

return sources
