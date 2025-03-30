local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local create_dialogue = require(ReplicatedStorage.common.utility.create_dialogue)
local world = require(ReplicatedStorage.common.ecs.world)

local DIALOGUE = create_dialogue.DIALOGUE
local CHOICE = create_dialogue.CHOICE
local RESPONSE = create_dialogue.RESPONSE
local IF = create_dialogue.IF

type props = {
	npc: Model,
}

local key = "test_condition_dialogue_1"
local function create_convo(props: props)
	local me = Players.LocalPlayer.Name

	local function create_cond(value: number)
		return function()
			task.wait(3)
			-- we should be able to yield here

			return value == 4
		end
	end

	local dialogue_id = DIALOGUE {
		key = key,

		RESPONSE {
			text = `Hello, I see that you want to do some condition verification check.`,
			RESPONSE {
				text = `Let's get started. Is 2+2 = 3?`,
				CHOICE {
					text = `Yes! That HAS to be correct`,
					IF(create_cond(3)) {
						success = {
							RESPONSE {
								text = `Huh? Is the game broken?`,
							},
						},
						failure = {
							RESPONSE {
								text = `Thats not correct bro!`,
							},
						},
					},
				},
				CHOICE {
					text = `What no? Its 5??`,
					IF(create_cond(5)) {
						success = {
							RESPONSE {
								text = `Nah the game is DEFINITELY broken LOL`,
							},
						},
						failure = {
							RESPONSE {
								text = `Thats not correct bro!`,
							},
						},
					},
				},
				CHOICE {
					text = `Nah, its 4 Lil bro`,
					IF(create_cond(4)) {
						success = {
							RESPONSE {
								text = `Hurray! You got it right? `,
								CHOICE {
									text = `Im the best`,
								},
								CHOICE {
									text = `Some call me einstein`,
									RESPONSE {
										text = "hehe",
									},
								},
							},
						},
						failure = {
							RESPONSE {
								text = `Tzzzz!`,
							},
						},
					},
				},
			},
		},
	}

	world:set(dialogue_id, components.DialogueAuthor, props.npc.Name)

	return dialogue_id
end

return {
	key = key,
	dialogue = create_convo,
}
