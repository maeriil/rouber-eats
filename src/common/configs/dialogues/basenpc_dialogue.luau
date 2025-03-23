local ReplicatedStorage = game:GetService("ReplicatedStorage")
local create_dialogue = require(ReplicatedStorage.common.utility.create_dialogue)
local jecs = require(ReplicatedStorage.pkg.jecs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair

local DIALOGUE = create_dialogue.DIALOGUE
local CHOICE = create_dialogue.CHOICE
local CALLBACK = create_dialogue.CALLBACK
local GOTO = create_dialogue.GOTO
local CONDITION = create_dialogue.CONDITION

local function fire_to_server()
	warn("ran a callback at this point")
end

local function test_print()
	warn("hahahahaha")
end

local function await_server_feedback()
	return false
end

local function generate_money()
	return 1000
end

return function(npc: Model)
	return DIALOGUE {
		npc = npc,
		initial_text = "Welcome to the Store. How can I help you?",
		key = "initial",

		CHOICE {
			usertext = "I'm good",
			response = "Okay no worries!",
		},
		CHOICE {
			usertext = function()
				return `Can i get {generate_money()} coins?`
			end,
			response = "Let me verify...",
			CONDITION(await_server_feedback) {
				SUCCESS = {
					CHOICE {
						usertext = "Thank you so much",
						response = "No problem!",
					},
					CALLBACK {
						fire_to_server,
					},
				},
				FAILURE = {
					CHOICE {
						usertext = "Uh-oh, my card declined",
						response = "Well then you can't buy anything then",
						CHOICE {
							usertext = "Oh no. Well can I still look around?",
							response = "Of course!",
							GOTO {
								key = "initial",
							},
						},
					},
				},
			},
		},
	}
end
