local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eventqueue = require(ReplicatedStorage.client.app.ui_store.eventqueue)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local map: {
	[eventqueue.qevent_types]: (...any) -> (),
} = {
	["DialogueChoiceSelected"] = function(payload: () -> Entity)
		local choice = payload()
		if not world:contains(choice) then
			error(`Failed to properly setup the id for the dialogue choice. This is a bug, file an issue`)
		end

		print("about to makr it as active choice gang")
		world:add(choice, c.ActiveDialogue)
	end,
	["DialoguePromptStarted"] = function(payload: () -> Model)
		local npc = payload()
		local id = ref(npc)

		-- Some way to start the dialog chain
		local start_dialog_id = world:target(id, c.DialogueOf) :: Entity
		if not start_dialog_id or not world:contains(start_dialog_id) then
			error(`Failed to find a valid dialogue within the npc {npc.Name} of {id}`)
		end
		world:add(start_dialog_id, c.Start)
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
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
