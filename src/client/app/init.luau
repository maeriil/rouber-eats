local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dialogue_choices = require(script.components.dialogue.dialogue_choices)
local dialogue_frame = require(script.components.dialogue.dialogue_frame)
local dialogue_start = require(script.components.dialogue.dialogue_start)
local eventqueue = require(script.ui_store.eventqueue)
local frame = require(script.components.pane.frame)
local gamepage = require(script.pages.gamepage)
local h = require(script.components.label.h)
local phonehomepage = require(script.pages.phonehomepage)
local ui_pages = require(script.ui_store.ui_pages)
local ui_store = require(script.ui_store)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local switch = vide.switch
local indexes = vide.indexes

local function FatalScreen(props)
	return frame {
		size = UDim2.new(1, 0, 1, 0),
		color = Color3.fromRGB(255, 0, 0),
		h {
			text = "Page in Construction",
		},
	}
end

local show = vide.show

local function attach_billboard_to_npc(props)
	return indexes(
		ui_store.NPCToAttachDialogues,
		function(char: () -> Model, a1: number)
			local character = char()
			local head = character:FindFirstChild("Icon") :: Part
			return create "BillboardGui" {
				Adornee = head,
				AlwaysOnTop = true,
				Size = function()
					return UDim2.new(0, 1000, 0, 100)
				end,
				StudsOffset = function()
					return vector.create(0, 2, 0)
				end,
				ResetOnSpawn = false,
				Active = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

				show(ui_store.IsTalkingWithNPC, function()
					return {
						dialogue_frame {
							response = ui_store.DialogueResponse,
							author = ui_store.DialogueAuthor,
						},
						dialogue_choices {
							list = ui_store.DialogueChoices,
							pass = eventqueue.add_dialogue_event_choice,
						},
					}
				end, function()
					return dialogue_start {
						pass = function()
							eventqueue.add_dialogue_started(character)
						end,
					}
				end),
			}
		end
	)
end

local function root(): { any }
	local page = ui_store.page

	return {
		attach_billboard_to_npc {},
		create "ScreenGui" {
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			switch(page) {
				[ui_pages.Game] = function()
					return gamepage {
						page = page,
					}
				end,
				[ui_pages.Shop] = function()
					return FatalScreen {}
				end,
				[ui_pages.Delivery] = function()
					return FatalScreen {}
				end,
				[ui_pages.PhoneHome] = function()
					return phonehomepage {
						page = page,
					}
				end,
			},
		},
	}
end

return root
