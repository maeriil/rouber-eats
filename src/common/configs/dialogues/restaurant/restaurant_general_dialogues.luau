local ReplicatedStorage = game:GetService("ReplicatedStorage")
local attributes = require(ReplicatedStorage.types.attributes)
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local clientevents = require(ReplicatedStorage.common.clientevents)
local components = require(ReplicatedStorage.common.ecs.components)
local create_dialogue = require(ReplicatedStorage.common.utility.create_dialogue)
local luausignal = require(ReplicatedStorage.common.utility.luausignal)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local DIALOGUE = create_dialogue.DIALOGUE
local CHOICE = create_dialogue.CHOICE
local RESPONSE = create_dialogue.RESPONSE
local IF = create_dialogue.IF

local key = "restaurant_general"

type props = {
	npc: Model,
}

local verify_order_signal: luausignal.Identity<boolean, string?> = luausignal()

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
	local server_house_id = interior:GetAttribute(attributes.serverid) :: types.Entity?

	if server_house_id == nil then
		error(
			`We could not find a server entity id on the model... This is definitely not right either`
		)
	else
		warn(`LMAO we found the server id, this is hacky though, don't do this...`)
	end

	local error_msg_handling = ``

	local function create_awaiting_server_verification(restuarant_id: types.Entity)
		return function()
			clientevents.RouberOrders.i_want_to_pickup_order.fire(blink_conv.from_entity(restuarant_id))

			local res, msg = verify_order_signal:wait()
			warn(`We recieved the results in signal as {res}, and msg as {msg}`)
			if msg then
				error_msg_handling = msg
			end

			return res
		end
	end

	local restaurant_name = `Tim Horton's`
	local function select_choice_to_steal() end
	local function select_choice_to_tamper() end
	local function select_choice_to_deliver() end

	local dialogue_id = DIALOGUE {
		key = key,
		RESPONSE {
			text = `Welcome to {restaurant_name}!`,
			RESPONSE {
				text = `How can I help you today?`,
				CHOICE {
					text = `I'm just browsing for now!`,
					RESPONSE {
						text = `No worries! Let me know when you are ready!`,
					},
				},
				CHOICE {
					text = `Here to pickup my order!`,
					IF(create_awaiting_server_verification(server_house_id)) {
						success = {
							RESPONSE {
								text = `Yup, everything looks correc! Here is the order.`,
								CHOICE {
									text = `Perfect. Going to deliver this right away!`,
									RESPONSE {
										text = `Sounds good! Thanks and have a great day!`,
									},
								},
								CHOICE {
									text = `Actually, I know the owner and they told me to modify this slightly`,
									RESPONSE {
										text = `Did they really say that?`,
										CHOICE {
											text = `Yes. I am sure`,
											--//TODO: IMPLEMENT Callback here
											RESPONSE {
												text = `Fair enough, here is your order! Have a great day!`,
											},
										},
										CHOICE {
											text = `No, I would like to rethink my decision`,
											--//TODO: IMPLEMENT GOTO HERE
										},
									},
								},
								CHOICE {
									text = `I spoke with the owner and they told me I can keep it!`,
									RESPONSE {
										text = `Are you sure? You cannot change this decision`,
										CHOICE {
											text = `Yes. I am sure`,
											--//TODO: IMPLEMENT Callback here
											RESPONSE {
												text = `Fair enough, here is your order! Have a great day!`,
											},
										},
										CHOICE {
											text = `No, I would like to rethink my decision`,
											--//TODO: IMPLEMENT GOTO HERE
										},
									},
								},
							},
						},
						failure = {
							RESPONSE {
								text = `You do not have a valid order! {error_msg_handling}`,
							},
						},
					},
				},
			},
		},
	}

	world:set(dialogue_id, components.DialogueAuthor, npc_name)
	return dialogue_id
end

return {
	key = key,
	dialogue = dialogue,
	verify_order_signal = verify_order_signal,
}
