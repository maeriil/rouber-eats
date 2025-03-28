local ReplicatedStorage = game:GetService("ReplicatedStorage")
local change_page = require(ReplicatedStorage.client.app.utility.change_page)
local dialogues = require(ReplicatedStorage.common.configs.dialogues)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local handle_proximity_interaction =
	require(ReplicatedStorage.common.utility.handle_proximity_interaction)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local map: {
	[eventqueue.qevent_types]: (...any) -> (),
} = {
	["DialogueNextResponse"] = function(payload: () -> Entity?)
		local id = payload()
		if not id or not world:contains(id) then
			error(`The specified entity does not contain in the world`)
		end

		local my_config = world:get(id, c.MyDialogue)
		assert(my_config, `Config must exist on the dialogueid`)

		my_config.action_completed = true
	end,
	["DialogueChoiceSelected"] = function(payload: () -> Entity)
		-- Now, when we click on this, we should let our system know that we clicked on next
		-- How can we do so? we can just mark the current one as completed (?)
		local choice_id = payload()

		if not world:contains(choice_id) then
			error(
				`We selected a choice id {choice_id} that does not exist in world. This should never happen.`
			)
			return
		end

		local id = uistore.MyDialogueId() :: types.Entity
		local my_config = world:get(id, c.MyDialogue)
		assert(my_config, `Config must exist on the dialogueid`)

		my_config.action_completed = true
		my_config.dialogue_choice = choice_id
	end,
	["DialoguePromptStarted"] = function(payload: () -> types.Entity)
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

		local my_dialogue_id = world:entity()
		world:set(my_dialogue_id, c.MyDialogue, {
			id = dialogue_entity_id,
			current_position = dialogue_entity_id,
			completed = false,
		})
		world:add(my_dialogue_id, c.Start)
	end,

	["ProximityClicked"] = function(payload: () -> types.ActiveProximity)
		handle_proximity_interaction(payload())
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
