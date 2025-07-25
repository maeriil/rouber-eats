local ReplicatedStorage = game:GetService("ReplicatedStorage")
local queue = require(ReplicatedStorage.common.utility.queue)
local types = require(ReplicatedStorage.types)
local uistore = require(script.Parent)
local vide = require(ReplicatedStorage.pkg.vide)

type queue<T> = queue.Queue<T>
type Entity = types.Entity
export type qevent_types =
	"UIOpen"
	| "UIClose"
	| "DialogueChoiceSelected"
	| "DialoguePromptStarted"
	| "DialogueNextResponse"
	| "ProximityClicked"
	| "OrderAccept"
	| "pose_select"
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

local function add_dialogue_started(npc_id: Entity)
	local payload = function()
		return npc_id
	end

	event_queue:add({
		type = "DialoguePromptStarted",
		payload = payload,
	})
end

local function dispatch_next_dialogue(id: Entity)
	local payload = function()
		return id
	end

	event_queue:add({
		type = "DialogueNextResponse",
		payload = payload,
	})
end

local function dispatch_pose_select(pose_kind: string)
	local payload = function()
		return pose_kind, uistore.ActiveOrder()
	end

	event_queue:add {
		type = "pose_select",
		payload = payload,
	}
end

local function add_ui_openclose_event(page: string)
	local payload = function()
		return page
	end

	return action(function()
		warn(`Opening the page {page}`)
		event_queue:add({
			type = "UIOpen",
			payload = payload,
		})

		cleanup(function()
			warn(`Closing the page {page}`)
			event_queue:add({
				type = "UIClose",
				payload = payload,
			})
		end)
	end)
end

local function dispatch_proximity_clicked(activeproximity: types.ActiveProximity)
	local payload = function()
		return activeproximity
	end

	event_queue:add({
		type = "ProximityClicked",
		payload = payload,
	})
end

local function dispatch_order_accept(client_order_id: types.Entity)
	local payload = function()
		return client_order_id
	end

	event_queue:add({
		type = "OrderAccept",
		payload = payload,
	})
end

return {
	queue = event_queue,
	add_dialogue_event_choice = add_dialogue_event_choice,
	add_ui_openclose_event = add_ui_openclose_event,
	add_dialogue_started = add_dialogue_started,
	dispatch_next_dialogue = dispatch_next_dialogue,
	dispatch_proximity_clicked = dispatch_proximity_clicked,
	dispatch_order_accept = dispatch_order_accept,
	dispatch_pose_select = dispatch_pose_select,
}
