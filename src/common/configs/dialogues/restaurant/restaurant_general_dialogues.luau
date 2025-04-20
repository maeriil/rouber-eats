-- stylua: ignore start
local ReplicatedStorage             = game:GetService("ReplicatedStorage")
local attributes                    = require(ReplicatedStorage.types.attributes)
local create_dialogue               = require(ReplicatedStorage.common.utility.create_dialogue)
local luausignal                    = require(ReplicatedStorage.common.utility.luausignal)
local server_id_map                 = require(ReplicatedStorage.client.store.server_id_map)
local restaurant = require(ReplicatedStorage.common.configs.restaurant)

local try_altering_order_event      = require(ReplicatedStorage.common.events.order.try_altering_order_event)
local invoke_delivering_order_event = require(ReplicatedStorage.common.events.order.invoke_delivering_order_event)
local try_picking_up_order_event    = require(ReplicatedStorage.common.events.order.try_pickup_order_event)
local try_keeping_order_event       = require(ReplicatedStorage.common.events.order.try_keeping_order_event)

local t                             = require(ReplicatedStorage.types)
local c                             = require(ReplicatedStorage.common.ecs.components)
local world                         = require(ReplicatedStorage.common.ecs.world)

local verify_order_signal  : luausignal.Identity<boolean, string> = luausignal()
local steal_success_signal : luausignal.Identity<boolean, string> = luausignal()
local alter_success_signal : luausignal.Identity<boolean, string> = luausignal()

local DIALOGUE = create_dialogue.DIALOGUE
local CALLBACK = create_dialogue.CALLBACK
local CHOICE   = create_dialogue.CHOICE
local RESPONSE = create_dialogue.RESPONSE
local IF       = create_dialogue.IF
local GOTO     = create_dialogue.GOTO
-- stylua: ignore end

local key = "restaurant_general"

type props = {
	npc: Model,
}

local function dialogue(props: props)
	local npc_name = props.npc.Name

	--[[
	TODO
		The solution below is HACKY. Do NOT do this lmao. Find a better way.
		We are assuming the fact that a restuarant NPC is a descendant of NPC folder underneath
		the Interior. Then we can use `ref()` interior to kinda do voodoo magic...
	]]
	local npc_folder = props.npc.Parent :: Folder
	local interior = npc_folder.Parent :: Model
	local restaurant_attribute_name = interior:GetAttribute(attributes.restaurant_name_id) :: string
	local restaurant_config = restaurant[restaurant_attribute_name]

	local error_msg_handling = ``

	local function select_choice_to_steal()
		return function()
			try_keeping_order_event.to_server()

			local res, msg = steal_success_signal:wait()
			if not res then
				error_msg_handling = msg
			end

			return res
		end
	end

	local function select_choice_to_tamper()
		return function()
			try_altering_order_event.to_server()

			local res, msg = alter_success_signal:wait()
			if not res then
				error_msg_handling = msg
			end

			return res
		end
	end

	local function select_choice_to_deliver()
		-- This is by default should just be a callback function, that is, there is no need
		-- to await for server verification

		invoke_delivering_order_event.to_server()
	end

	local function await_server_pickup_verification(restaurant_name: string)
		return function()
			try_picking_up_order_event.to_server(restaurant_name)

			local res, msg = verify_order_signal:wait()
			if not res then
				error_msg_handling = msg
			end

			return res
		end
	end

	local dialogue_id = DIALOGUE {
		key = key,
		RESPONSE {
			text = `Welcome to {restaurant_attribute_name}!`,
			RESPONSE {
				text = `How can I help you today?`,
				key = "root_goto",
				CHOICE {
					text = `I'm just browsing for now!`,
					RESPONSE {
						text = `No worries! Let me know when you are ready!`,
					},
				},
				CHOICE {
					text = `Here to pickup my order!`,
					IF(await_server_pickup_verification(restaurant_attribute_name)) {
						success = {
							RESPONSE {
								text = function()
									return `Yup, everything looks correct! Here is the order!`
								end,
								RESPONSE {
									text = `What would you like to do with it?`,
									key = `choice_goto`,
									CHOICE {
										text = `Perfect. Going to deliver this right away!`,
										CALLBACK(select_choice_to_deliver) {
											RESPONSE {
												text = `Sounds good! Thanks and have a great day!`,
											},
										},
									},
									CHOICE {
										text = `I spoke with the owner and they told me I can keep it!`,
										RESPONSE {
											text = `Did they really say that?`,
											CHOICE {
												text = `Yes. I am sure`,
												IF(select_choice_to_steal()) {
													success = {
														RESPONSE {
															text = `Fair enough, here is your order! Have a great day!`,
														},
													},
													failure = {
														RESPONSE {
															text = function()
																return `No you do not! {error_msg_handling}`
															end,
															--// The order is still marked as in process, so we should force them to deliver it
															GOTO {
																key = "choice_goto",
															},
														},
													},
												},
											},
											CHOICE {
												text = `No, I would like to rethink my decision...`,
												GOTO {
													key = "choice_goto",
												},
											},
										},
									},
									CHOICE {
										text = `I spoke with the owner and they told me change it up slightly`,
										RESPONSE {
											text = `Are you sure? You cannot change this decision`,
											CHOICE {
												text = `Yes. I am sure`,
												IF(select_choice_to_tamper()) {
													success = {
														RESPONSE {
															text = `Fair enough, here is your order! I will show you to the kitchen`,
														},
													},
													failure = {
														RESPONSE {
															text = function()
																return `No you do not! {error_msg_handling}`
															end,
															--// The order is still marked as in process, so we should force them to deliver it
															GOTO {
																key = "choice_goto",
															},
														},
													},
												},
											},
											CHOICE {
												text = `No, I would like to rethink my decision...`,
												GOTO {
													key = "choice_goto",
												},
											},
										},
									},
								},
							},
						},
						failure = {
							RESPONSE {
								text = function()
									return `You do not have a valid order! {error_msg_handling}`
								end,
							},
						},
					},
				},
			},
		},
	}

	world:set(dialogue_id, c.DialogueAuthor, npc_name)
	return dialogue_id
end

return {
	key = key,
	dialogue = dialogue,
	verify_order_signal = verify_order_signal,
	steal_success_signal = steal_success_signal,
	alter_success_signal = alter_success_signal,
}
