local ReplicatedStorage = game:GetService("ReplicatedStorage")
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local jecs = require(ReplicatedStorage.pkg.jecs)
local p = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local t = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local pair = jecs.pair
local for_each_target = require(ReplicatedStorage.common.utility.for_each_target)
local future = require(ReplicatedStorage.pkg.future)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local dialogue_started = world:query(c.MyDialogue):with(c.Start):cached()

local function on_dialogue_started()
	local it = dialogue_started:iter()
	local my_id, configs = it()
	if not my_id then
		return
	end

	-- When the dialogue first starts, we want to disable most of humanoid's movemenet
	-- and reenable it after dialogue is completed
	local humanoid = world:get(c.Client, c.Humanoid)
	assert(humanoid ~= nil, `Humanoid must exist on client's character`)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false)

	-- This is the tree, and it should contain things like the author name, and the intial
	-- text that we populate in the uistore
	local dialogue_tree = configs.id
	local author = world:get(dialogue_tree, c.DialogueAuthor) :: string

	configs.system_completed = false
	configs.action_completed = true

	uistore.DialogueAuthor(author)
	uistore.MyDialogueId(my_id)
	world:remove(my_id, c.Start)
end

local dialogue_cleanup_query = world:query(c.MyDialogue):with(c.Cleanup):cached()
local function on_dialogue_cleanup()
	local it = dialogue_cleanup_query:iter()
	local my_id, configs = it()
	if not my_id then
		return
	end

	-- When cleanup occurs, we want to reset all the changes we made when we first started dialogue
	-- just refer to that function and revert changes

	local humanoid = world:get(c.Client, c.Humanoid)
	assert(humanoid ~= nil, `Humanoid must exist on client's character`)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, true)

	-- WE want to update the UI so we no longer show the dialogue pages
	go_back_page()

	uistore.DialogueResponse("")
	uistore.DialogueResponseId(nil :: never)
	uistore.DialogueAuthor("")
	uistore.MyDialogueId(nil :: never)
	uistore.DialogueChoices({})
	-- Finally, delete the entity and delete the parent node. Ensure that we delete all of the
	-- dialogue tree, Verify this in jabby

	world:delete(configs.id)
	world:delete(my_id)
end

local dialogue_general = world:query(c.MyDialogue):without(c.Cleanup):cached()
local function queue_next_dialogue_options()
	local it = dialogue_general:iter()
	local my_id, configs = it()
	if not my_id or not configs.action_completed then
		return
	end

	local node = configs.current_position
	if world:has(node, c.DialogueChoiceContainer) then
		-- If the current is dialogue choice container and user clicked on some action
		-- we want to grab it , verifiy it exists, then move our position to that index
		-- We also want to clear the dialogue choices source so it does the clearing animation
		local choice_id = configs.dialogue_choice

		if choice_id == nil then
			--[[
				if the choice id is nil, then it means player click on something other than choices
				that invoked action_completed to be true. In this, ignore it and makr action_completed back
				to false
			]]
			configs.action_completed = false
			return
		end

		node = choice_id
		uistore.DialogueChoices({})
		configs.dialogue_choice = nil
	elseif world:has(node, c.DialogueIf) then
		-- We are in condition, and it hasn't been resolved yet, so we just halt all the process\
		-- until the poll system manually updates thie config
		return
	elseif world:has(node, c.DialogueResponse) then
	else
	end

	-- Now, it means completed is true, which means we want to iterate over the next
	-- on the tree
	local next_id = world:target(node, c.Next)

	if next_id == nil then
		-- If no next is found, this means we have reached the end of the dialogue.
		-- This means that we should end the dialogue and start to perform clean
		warn(`TODO: Now we will need to perform dialogue cleanup`)
		world:add(my_id, c.Cleanup)
		return
	end

	configs.current_position = next_id

	-- If we do find next, now we need to determine what kind of dialogue this is
	-- If it is a condition, we need to start to build the future and spawn a seperate entity for it
	-- If it is a goto, we need to find traverse up until we find out

	if world:has(next_id, c.DialogueResponse) then
		--// TODO
		-- If the next response is a choice, we want to automatically display it
		-- We might need to introduce another source for this
		world:add(my_id, c.DialogueResponse)
	elseif world:has(next_id, c.DialogueChoiceContainer) then
		-- This means that now we are in a choice area, so now we have to grab allthe choices
		-- and add them to the dialogue choice array
		-- Also, when the user makes a selection, we need to clear up the array as well
		world:add(my_id, c.DialogueChoiceContainer)
	elseif world:has(next_id, c.DialogueIf) then
		-- This means we are now at a dialogue If conditoins. Dialogue if is a little tricky, we need
		-- to basically spawn a new entity with future wrapped on it and then poll it until we
		-- get back some result. After we do, we automatically move to the next dialogue depending on the
		-- response / failure

		local callback_to_wrap = world:get(next_id, c.DialogueIf) :: typeof(c.DialogueIf.__T)

		local futured = future.Future.new(callback_to_wrap)
		local condition_id = world:entity()
		world:set(condition_id, c.BoolFuture, futured)
		world:set(condition_id, pair(c.EntityId, c.DialogueIf), next_id)
		world:set(condition_id, pair(c.EntityId, c.MyDialogue), my_id)
	end

	configs.system_completed = false
end

local function poll_dialogue_condition()
	for id, future, my_id, dialogue_id in
		world:query(c.BoolFuture, pair(c.EntityId, c.MyDialogue), pair(c.EntityId, c.DialogueIf)):iter()
	do
		local poll = future:poll()
		if not poll:isReady() then
			continue
		end

		local unwrap_res = poll:unwrap()
		if unwrap_res:isErr() then
			local message = unwrap_res:unwrapErr()
			task.spawn(error, message)

			world:delete(id)
		end

		local condition_result = unwrap_res:unwrapOk()
		local config = world:get(my_id, c.MyDialogue) :: typeof(c.MyDialogue.__T)
		local success_id = world:target(dialogue_id, c.DialogueSuccess) :: t.Entity
		local failure_id = world:target(dialogue_id, c.DialogueFailure) :: t.Entity

		if condition_result then
			-- We should move on to the Dialogue Success
			config.current_position = success_id
		else
			-- We shold move on to the Dialgoue Failure
			config.current_position = failure_id
		end

		config.system_completed = true
		config.action_completed = true
		world:delete(id)
	end
end

local my_display_response_query = world:query(c.MyDialogue):with(c.DialogueResponse):cached()
local function display_response_to_ui()
	local it = my_display_response_query:iter()
	local my_id, configs = it()
	if not my_id or configs.system_completed then
		return
	end

	local current_node = configs.current_position
	local text = world:get(current_node, c.DialogueText) :: string

	uistore.DialogueResponse(text)
	uistore.DialogueResponseId(current_node)

	-- Now, we just need to wait until the user clicks or does some action
	world:remove(my_id, c.DialogueResponse)
	configs.system_completed = true
	configs.action_completed = false
end

local my_display_choices_query = world:query(c.MyDialogue):with(c.DialogueChoiceContainer):cached()
local function display_choices_to_ui()
	local it = my_display_choices_query:iter()
	local my_id, configs = it()
	if not my_id or configs.system_completed then
		return
	end

	local current_node = configs.current_position
	local choices_list = {} :: { { id: t.Entity, text: string } }

	for_each_target(current_node, c.Next, function(id)
		-- local choice_node = pair(c.Next, id)
		local text = world:get(id, c.DialogueText) :: string

		table.insert(choices_list, {
			id = id,
			text = text,
		})
	end)

	uistore.DialogueChoices(choices_list)

	world:remove(my_id, c.DialogueChoiceContainer)
	configs.system_completed = true
	configs.action_completed = false
end

local function system()
	on_dialogue_started()
	queue_next_dialogue_options()
	poll_dialogue_condition()
	display_response_to_ui()
	display_choices_to_ui()
	on_dialogue_cleanup()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
