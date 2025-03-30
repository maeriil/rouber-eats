local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local create_dialogue = require(ReplicatedStorage.common.utility.create_dialogue)
local world = require(ReplicatedStorage.common.ecs.world)

local DIALOGUE = create_dialogue.DIALOGUE
local CHOICE = create_dialogue.CHOICE
local RESPONSE = create_dialogue.RESPONSE
-- local CALLBACK = create_dialogue.CALLBACK
-- local IF = create_dialogue.IF

type props = {
	npc: Model,
}

local function create_basic_conversation(props: props)
	local name = props.npc.Name
	local me = Players.LocalPlayer.Name

	local dialogue_id = DIALOGUE {
		key = "test_dialogue",

		RESPONSE {
			text = `Hello, my name is {name}. What is your name?`,

			CHOICE {
				text = `My name is Bob`,
				RESPONSE {
					text = "some response....",
				},
			},
			CHOICE {
				text = `My name is Henry`,
				RESPONSE {
					text = "Are you sure you are henry?",
				},
			},
			CHOICE {
				text = `My name is {me}`,
				RESPONSE {
					text = `Hello {me}!`,
					RESPONSE {
						text = "How are you doing today?",
						CHOICE {
							text = "To be honest, not that greatl...",
						},
						CHOICE {
							text = "Doing great actually!",
						},
					},
				},
			},
			CHOICE {
				text = `None of your damn business!`,
			},
		},
	}

	world:set(dialogue_id, c.DialogueAuthor, name)

	return dialogue_id
end

return {
	key = "test_dialogue",
	dialogue = create_basic_conversation,
}
