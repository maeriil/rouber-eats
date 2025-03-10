local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local create_dialogue = require(ReplicatedStorage.common.utility.create_dialogue)
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local yetanothernet = require(ReplicatedStorage.pkg.yetanothernet)

local DIALOGUE = create_dialogue.DIALOGUE
local CHOICE = create_dialogue.CHOICE
local GOTO = create_dialogue.GOTO
local CONDITION = create_dialogue.CONDITION

return function(model: Model, restaurant: Model)
	local SuccessFailureChoice = {
		CHOICE {
			usertext = "Yes",
			response = "Thank you, we will let you know when it is ready",
		},
		CHOICE {
			usertext = "No",
			response = "Okay",
			GOTO {
				key = "prompt_food",
			},
		},
	}

	local function await_server_verification()
		local thread = coroutine.running()
		local status: boolean
		local timeout = false

		local connection = yetanothernet.createConnection(
			events.OrderVerificationStatus,
			function(response, by, received_status)
				print("INSIDE CONNECTION WE CREATED, WE FOUND SOMETHING")
				print(response, by, received_status)
				status = received_status
				local success, err = coroutine.resume(thread)
				if not success then
					error(err)
				end
			end
		)
		--route:send here
		events.IWantMyPickupOrderVerified:send(restaurant)
		warn(`CONNECTION STATUS IS`, connection.connected)
		task.delay(10, function()
			if status == nil then
				timeout = true
				warn(`CONNECTION STATUS IS`, connection.connected)

				local success, err = coroutine.resume(thread)
				if not success then
					error(err)
				end
			end
		end)

		coroutine.yield()
		connection:disconnect()

		if status == nil then
			return false
		else
			return status
		end
	end

	return DIALOGUE {
		npc = model,
		initial_text = `Hello, welcome to the {restaurant.Name}. How may I help you today?`,

		CHOICE {
			usertext = "Hi, I would like to order some food",
			response = "What would you like to get?",
			key = "prompt_food",
			CHOICE {
				usertext = "Hamburger",
				response = "Would that be all?",
				unpack(SuccessFailureChoice),
			},
			CHOICE {
				usertext = "Chicken Wings",
				response = "Would that be all?",
				unpack(SuccessFailureChoice),
			},
			CHOICE {
				usertext = "Salad",
				response = "Would that be all?",
				unpack(SuccessFailureChoice),
			},
			CHOICE {
				usertext = "You",
				response = "Would that be all?",
				unpack(SuccessFailureChoice),
			},
		},
		CHOICE {
			usertext = "Hey, I am here to pickup order",
			response = "Can you show me your order id?",
			CHOICE {
				usertext = `<i>Show your order Id<i>`,
				response = "One moment please.",
				CONDITION(await_server_verification) {
					SUCCESS = {
						CHOICE {
							usertext = "So..",
							response = "Everthing looks set, here is your order",
							CHOICE {
								usertext = "Thank you so much!",
								response = "You're welcome. Have a great day",
							},
						},
					},
					FAILURE = {
						CHOICE {
							usertext = "So..",
							response = "Couldn't validate your order. Please try again later",
							CHOICE {
								usertext = "Okay...",
								response = "SOrry :(",
							},
						},
					},
				},
			},
		},
		CHOICE {
			usertext = "Hi, I am still looking at the menu right now",
			response = "Okay, no worries. Take your time!",
		},
	}
end
