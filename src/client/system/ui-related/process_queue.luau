local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local dialogues = require(ReplicatedStorage.common.configs.dialogues)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)
local CREATE_UI_EVENT = require(ReplicatedStorage.client.client_utils.CREATE_UI_EVENT)

local c = require(ReplicatedStorage.common.ecs.components)
local handle_proximity_interaction =
	require(ReplicatedStorage.common.utility.handle_proximity_interaction)
local last_fired = require(ReplicatedStorage.common.utility.last_fired)
local phases = require(ReplicatedStorage.common.ecs.phases)
local throw_error = require(ReplicatedStorage.common.utility.throw_error)
local world = require(ReplicatedStorage.common.ecs.world)
local try_accept_order_event = require(ReplicatedStorage.common.events.order.try_accept_order_event)
local try_strike_order_pose_event =
	require(ReplicatedStorage.common.events.order.try_strike_order_pose_event)
local __ = jecs.Wildcard

local is_valid_time, update = last_fired(1)

local map: {
	[eventqueue.qevent_types]: (...any) -> (),
} = {
	["DialogueNextResponse"] = function(payload: () -> t.Entity?)
		local id = payload()
		if not id or not world:contains(id) then
			error(`The specified entity does not contain in the world`)
		end

		local my_config = world:get(id, c.MyDialogue)
		assert(my_config, `Config must exist on the dialogueid`)
		warn(`Next response is being displayed  (?)`)

		my_config.action_completed = true
	end,
	["DialogueChoiceSelected"] = function(payload: () -> t.Entity)
		-- Now, when we click on this, we should let our system know that we clicked on next
		-- How can we do so? we can just mark the current one as completed (?)
		local choice_id = payload()

		if not world:contains(choice_id) then
			error(
				`We selected a choice id {choice_id} that does not exist in world. This should never happen.`
			)
			return
		end

		local id = uistore.MyDialogueId() :: t.Entity
		local my_config = world:get(id, c.MyDialogue)
		assert(my_config, `Config must exist on the dialogueid`)

		my_config.action_completed = true
		my_config.dialogue_choice = choice_id
	end,
	["DialoguePromptStarted"] = function(payload: () -> t.Entity)
		local id = payload()

		if not world:contains(id) then
			error(`The specified entity does not contain in the world`)
		end

		local npc, dialogueconfig = world:get(id, c.Model, c.HasDialogue)

		-- At this point everything is valid so now we start the dialogue by spawning a new
		-- dialogue entity on the local player (?)
		-- And we change page to rendering dialogue one
		assert(npc ~= nil, "NPC must be defined")
		assert(dialogueconfig, `Dialgoue configuration must exist in the entity`)
		change_page("DialogueScene")

		local dialogue_func = dialogues[dialogueconfig.dialogue_id]
		local dialogue_entity_id = dialogue_func({
			npc = npc,
		})

		warn(`DialoguePromptstarted is invoked...`)

		local my_dialogue_id = world:entity()
		world:set(my_dialogue_id, c.MyDialogue, {
			id = dialogue_entity_id,
			current_position = dialogue_entity_id,
			completed = false,
		})
		world:add(my_dialogue_id, c.Start)
	end,

	["ProximityClicked"] = function(payload: () -> t.ActiveProximity)
		handle_proximity_interaction(payload())
	end,

	["OrderAccept"] = function(payload: () -> t.Entity)
		local player = Players.LocalPlayer
		if not is_valid_time(player) then
			warn(`You are spam clicking it too much. Aborting the request`)
			return
		end

		local client_order_id = payload()
		if client_order_id == nil or not world:contains(client_order_id) then
			warn(`Client world could not find a client id {client_order_id}. This has to be abug...`)
			return
		end

		-- When we select order it must have order details component right
		local details = world:has(client_order_id, c.DeliveryOrderDetails)
		if not details then
			return warn(`Passed an client id {client_order_id} that is not an order. Ignoring request`)
		end

		local server_entity_id = world:get(client_order_id, c.EntityId) :: t.Entity
		-- clientevents.RouberOrders.i_want_to_accept_order.fire(blink_conv.from_entity(server_entity_id))

		try_accept_order_event.to_server(server_entity_id)
		update(player)
	end,
	["pose_select"] = function(payload: () -> (t.rouber_pose_t, t.Entity))
		local pose_kind: t.rouber_pose_t, order_id = payload()

		if not order_id or not world:contains(order_id) then
			throw_error(`Sending an unknown order_id to pose_select`)
			return
		end

		local server_order_id = world:exists_get(order_id, c.EntityId) :: t.Entity
		try_strike_order_pose_event.to_server(server_order_id, pose_kind)
	end,
	["UIOpen"] = function(payload: () -> t.GamePages)
		local page_changed_to: t.GamePages = payload()

		if page_changed_to == "RouberScreen" then
			CREATE_UI_EVENT(c.UI_update_orders_list)
		end
	end,
}

local function system()
	for item in eventqueue.queue:iter() do
		local type: eventqueue.qevent_types = item.type
		local payload = item.payload
		local callback = map[type]

		if not callback then
			continue
		end

		callback(payload)
	end

	eventqueue.queue:clear()
end

return {
	name = script.Name,
	system = system,
	phase = phases.First,
	runConditions = {},
}
