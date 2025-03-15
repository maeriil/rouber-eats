local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HudScreen = require(script.pages.HudScreen)
local PhoneScreen = require(script.pages.PhoneScreen)
local RouberScreen = require(script.pages.RouberScreen)
local frame = require(script.components.pane.frame)
local types = require(ReplicatedStorage.types)
local uistore = require(script.uistore)
local use_px = require(script.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local switch = vide.switch
-- local switch = vide.switch
-- local indexes = vide.indexes

-- local function FatalScreen(props)
-- 	return frame {
-- 		size = UDim2.new(1, 0, 1, 0),
-- 		color = Color3.fromRGB(255, 0, 0),
-- 		h {
-- 			text = "Page in Construction",
-- 		},
-- 	}
-- end

-- local show = vide.show

-- local function attach_billboard_to_npc(props)
-- 	return indexes(ui_store.NPCToAttachDialogues, function(char: () -> Model, a1: number)
-- 		local character = char()
-- 		local head = character:FindFirstChild("Icon") :: Part
-- 		return create "BillboardGui" {
-- 			Adornee = head,
-- 			AlwaysOnTop = true,
-- 			Size = function()
-- 				return UDim2.new(0, 1000, 0, 100)
-- 			end,
-- 			StudsOffset = function()
-- 				return vector.create(0, 2, 0)
-- 			end,
-- 			ResetOnSpawn = false,
-- 			Active = true,
-- 			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,

-- 			show(ui_store.IsTalkingWithNPC, function()
-- 				return {
-- 					dialogue_frame {
-- 						response = ui_store.DialogueResponse,
-- 						author = ui_store.DialogueAuthor,
-- 					},
-- 					dialogue_choices {
-- 						list = ui_store.DialogueChoices,
-- 						pass = eventqueue.add_dialogue_event_choice,
-- 					},
-- 				}
-- 			end, function()
-- 				return dialogue_start {
-- 					pass = function()
-- 						eventqueue.add_dialogue_started(character)
-- 					end,
-- 				}
-- 			end),
-- 		}
-- 	end)
-- end

local function root(): { any }
	-- local page = ui_store.page
	use_px.use_px()
	local page = uistore.page
	local hud: types.GamePages = "HudScreen"
	local phone: types.GamePages = "PhoneScreen"
	local rouber: types.GamePages = "RouberScreen"

	return {
		-- attach_billboard_to_npc {},
		create "ScreenGui" {
			use_px.use_px(),
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = Enum.ScreenInsets.None,

			switch(page) {
				[""] = function()
					return frame {
						size = UDim2.new(1, 0, 1, 0),
						create "TextLabel" {
							Size = UDim2.new(1, 0, 1, 0),
							BackgroundTransparency = 1,
							TextSize = 96,
							Text = "Unkown page is shown",
						},
					}
				end,
				[hud] = function()
					return HudScreen {}
				end,
				[phone] = function()
					return PhoneScreen {}
				end,
				[rouber] = function()
					return RouberScreen {}
				end,
			},
		},
	}
end

return root

--[[

component dialogue {
	current: Entity;
	selected: Entity; -- What choice the user made
	root: Entity; -- The root of the dialogue tree
}

start_dialogue () {
	event = world:entity()
	world:set(even, dialogue, {
		current: root,
		root: root,
		loaded: false,
		next_invoked: false,
	})
}

determine_next () {
	ui should notify that user did something, whether it be choice, or go next

	choice = from input
	if choice is nil then

	if choice is not nil then
		next_invoked, user_selection
}


handle_condition_async () {
	iterate all dialogue with future {
		poll for result
		status = unwrap the result

		if status is true {
			dialogue.current = world_get(dialogue.current, success_id?)
		else
			dialogue.current = world_get(dialogue.current, failure_id?)
		}
		next_invoked = true
	}
}

handle_dialogue () {
	iterate all dialogue {
		if not nextinvoked then continue
		next_invoked = false
		determine what kind of dialogue.current is

		if current is condition then
			world:set(i, futurecomponent)
		if current is goto then
			dialogue.current = gotovalue
			loaded = false
			next_invoked = true
		if current is execute callbacks then
			execute_callbacks
			next_invoked = true

		if current is a just a display message
			loaded = false
			display_type = "Message"
		if current is a choice then
			loaded = false,
			display_choices = "Choices"
	}
}

display_dialogue () {
	iterate all dialogoue {
		if loaded then return
		loaded = true
		if type = response {
			local current = world:get(current, Message)
			DialogueSource("urrent)
		} if type = cohice {
			Choices({ ... })
		}

		end
	}
}



]]
