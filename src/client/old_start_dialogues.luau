local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local queue = require(ReplicatedStorage.common.utility.queue)
local world = require(ReplicatedStorage.common.ecs.world)
local future = require(ReplicatedStorage.pkg.future).Future
local __ = jecs.Wildcard

local function queue_dialogues(at: Entity, kind: Entity)
	local dialoguequeue = queue.new() :: queue.Queue<Entity>
	local n = 0
	while true do
		local current = world:target(at, kind, n)
		if current == nil then
			break
		end
		dialoguequeue:add(current)
		n += 1
	end

	if n > 0 then
		world:set(at, c.PendingChoices, dialoguequeue)
	else
		world:add(at, c.TerminateDialogue)
	end
end

local dialogue_start_q = world:query(c.Dialogue):with(c.Start):cached()
local function start_dialogue()
	for i, details in dialogue_start_q:iter() do
		world:remove(i, c.Start)
		uistore.DialogueAuthor(details.author)
		uistore.DialogueResponse(details.initial_text)
		uistore.DialogueResponseId(i)
		uistore.IsTalkingWithNPC(true)

		world:add(i, c.ActiveDialogue)
	end
end

local function process_active_dialogue()
	for i in world:each(c.ActiveDialogue) do
		local details = world:get(i, c.DialogueDetails)
		if details then
			local text = if type(details.response) == "function"
				then details.response()
				else details.response
			uistore.DialogueResponse(text)
			uistore.DialogueResponseId(i)
		end

		world:remove(i, c.ActiveDialogue)
		local condition = world:get(i, c.DialogueCondition)
		if condition then
			-- Create the future stuff here and add it
			local future_condition = future.new(function(...)
				return condition()
			end)
			world:set(i, c.PendingConditions, future_condition)
			continue
		end

		local callback_list = world:get(i, c.DialogueCallbacks)
		if callback_list then
			for _, callback in callback_list do
				callback()
			end
		end

		local goto = world:get(i, c.GoTo)
		if goto then
			queue_dialogues(goto, c.Choice)
			continue
		end

		queue_dialogues(i, c.Choice)
	end
end

local function condition_poll_system()
	for i, condition in world:query(c.PendingConditions):iter() do
		local poll = condition:poll()
		if poll:isPending() then
			continue
		end

		local poll_result = poll:unwrap()
		if poll_result:isOk() then
			local evaluated = poll_result:unwrapOk()

			if evaluated then
				queue_dialogues(i, c.Choice)
			else
				queue_dialogues(i, c.FallbackChoice)
			end
			world:remove(i, c.PendingConditions)
		end
	end
end

local function render_dialog_choices()
	for i, choicequeue in world:query(c.PendingChoices):iter() do
		local content = {}
		for entity in choicequeue:iter() do
			local details = world:get(entity, c.DialogueDetails)
			assert(details ~= nil)

			local text = if type(details.usertext) == "function"
				then details.usertext()
				else details.usertext

			table.insert(content, {
				id = entity,
				text = text,
			})
		end
		choicequeue:clear()

		uistore.DialogueChoices(content :: any)
		world:remove(i, c.PendingChoices)
		world:remove(i, c.ActiveDialogue)
	end
end

local function terminate_dialogue()
	for i in world:each(c.TerminateDialogue) do
		world:remove(i, c.TerminateDialogue)
		uistore.IsTalkingWithNPC(false)
	end
end

local function system()
	-- start_dialogue()
	-- process_active_dialogue()
	-- condition_poll_system()
	-- render_dialog_choices()
	-- terminate_dialogue()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}

--[[


Root {
  id = 'dialogue_id',

  response {
    key="one"
    choice {
			text = ""
      response {
			text = ""
        response {
          response {
            callback(func_here) {
              goto {
                key="one"
              }
            }

          }
        }
      }
    }
    choice {}
    choice {
      condition(func_here) {
        success = {
          response {}
        }
        failure = {
          callback(func_here) {
            choice {}
            choice {}
          }
        }
      }
    }
  }
}



]]
