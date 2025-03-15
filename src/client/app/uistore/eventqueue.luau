local ReplicatedStorage = game:GetService("ReplicatedStorage")
local queue = require(ReplicatedStorage.common.utility.queue)
local types = require(ReplicatedStorage.types)
local vide = require(ReplicatedStorage.pkg.vide)

type queue<T> = queue.Queue<T>
type Entity = types.Entity
export type qevent_types = "UIOpen" | "UIClose" | "DialogueChoiceSelected" | "DialoguePromptStarted"
export type qevent = {
	type: qevent_types,
	payload: (() -> any)?,
}

local action = vide.action
local cleanup = vide.cleanup
local event_queue = queue.new() :: queue<qevent>

local function add_dialogue_event_choice(id: Entity)
	local payload = function()
		return id
	end

	event_queue:add({
		type = "DialogueChoiceSelected",
		payload = payload,
	})
end

local function add_dialogue_started(npc: Model)
	local payload = function()
		return npc
	end

	event_queue:add({
		type = "DialoguePromptStarted",
		payload = payload,
	})
end

local function add_ui_openclose_event(page: string)
	local payload = function()
		return page
	end

	return action(function()
		event_queue:add({
			type = "UIOpen",
			payload = payload,
		})

		cleanup(function()
			event_queue:add({
				type = "UIClose",
				payload = payload,
			})
		end)
	end)
end

return {
	queue = event_queue,
	add_dialogue_event_choice = add_dialogue_event_choice,
	add_ui_openclose_event = add_ui_openclose_event,
	add_dialogue_started = add_dialogue_started,
}
