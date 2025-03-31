local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local t = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

type TABLE = { [any]: any }

-- local function is_choice(v: any)
-- 	return type(v) == "table" and v._choice
-- end
local function is_response(v: any)
	return type(v) == "table" and v._response
end
local function is_callback(v: any)
	return type(v) == "table" and v._callback
end
local function is_if(v: any)
	return type(v) == "table" and v._if
end
local function is_goto(v: any)
	return type(v) == "table" and v._goto
end

local function RESPONSE(props: TABLE & {
	text: string | (() -> string),
})
	return {
		_response = true,
		props = props,
	}
end

local function CHOICE(props: TABLE & {
	text: string | (() -> string),
})
	return {
		_choice = true,
		props = props,
	}
end

local function CALLBACK(callback: () -> ())
	return function(props: TABLE)
		return {
			_callback = true,
			func = callback,
			props = props,
		}
	end
end

local function GOTO(props: TABLE & {
	key: string,
})
	return {
		_goto = true,
		props = props,
	}
end
local function IF(check_function: () -> boolean)
	return function(props: { success: TABLE, failure: TABLE })
		return {
			_if = true,
			check = check_function,
			success = props.success,
			failure = props.failure,
			props = props,
		}
	end
end

local build_dialogue_tree: (parent: t.Entity, node: TABLE) -> t.Entity
local build_choices: (parent: t.Entity, node: TABLE) -> ()

local function create_choicecontainer(parent)
	local container_id = world:entity() :: t.Entity
	world:set(container_id, c.Parent, parent)
	world:add(parent, pair(c.Next, container_id))
	world:add(container_id, c.DialogueChoiceContainer)
	return container_id
end

local function create_choice(parent, t)
	local choice_id = world:entity() :: t.Entity
	world:set(choice_id, c.Parent, parent)
	world:add(choice_id, c.DialogueChoice)
	world:set(choice_id, c.DialogueText, t.props.text)
	world:add(parent, pair(c.Next, choice_id))
	return choice_id
end

local function create_response(parent: t.Entity, dialogue_text: string)
	local response_id = world:entity() :: t.Entity
	world:add(parent, pair(c.Next, response_id))
	world:add(response_id, c.DialogueResponse)
	world:set(response_id, c.Parent, parent)
	world:set(response_id, c.DialogueText, dialogue_text)

	return response_id
end

local function create_if(parent, check_function, success, failure)
	-- I think this one might have bugs
	local if_id = world:entity() :: t.Entity
	world:add(parent, pair(c.Next, if_id))
	world:set(if_id, c.Parent, parent)
	world:set(if_id, c.DialogueIf, check_function)
	world:set(if_id, c.DialogueText, "todo... add condition text")

	local success_id = world:entity() :: t.Entity
	world:add(success_id, c.DialogueSuccess)
	if #success > 1 then
		build_choices(success_id, success)
	else
		local _, next_node = next(success)
		build_dialogue_tree(success_id, next_node)
	end
	world:add(if_id, pair(c.DialogueSuccess, success_id))

	local failure_id = world:entity() :: t.Entity
	world:add(failure_id, c.DialogueFailure)
	if #failure > 1 then
		build_choices(failure_id, failure)
	else
		local _, next_node = next(failure)
		build_dialogue_tree(failure_id, next_node)
	end
	world:add(if_id, pair(c.DialogueFailure, failure_id))

	return if_id
end

local function create_callback(parent: t.Entity, callback: () -> ())
	local callback_id = world:entity() :: t.Entity
	world:set(callback_id, c.Parent, parent)
	world:add(parent, pair(c.Next, callback_id))
	world:set(callback_id, c.DialogueCallback, callback)

	return callback_id
end

local function create_goto(parent, props)
	warn(`todo, goto needs some work...`)
	local goto_id = world:entity() :: t.Entity
	world:set(goto_id, c.Parent, parent)
	world:set(goto_id, c.DialogueGoto, props.target)
	world:add(parent, pair(c.Next, goto_id))
	return goto_id
end

-- WE will need to create other things like create_response etc as well
function build_choices(parent: t.Entity, props: TABLE)
	local container_id = create_choicecontainer(parent)
	for _, choice in ipairs(props) do
		local choice_id = create_choice(container_id, choice)
		local num_of_children = #choice.props

		if num_of_children > 1 then
			build_choices(choice_id, choice.props)
		else
			local _, choice_nextnode = next(choice.props)
			build_dialogue_tree(choice_id, choice_nextnode)
		end
	end

	return
end

function build_dialogue_tree(parent, node)
	if not node or typeof(node) == "function" or not node.props then
		return parent
	end

	local _, next_node = next(node.props)
	if is_response(node) then
		local response_id = create_response(parent, node.props.text)

		local num_of_children = #node.props
		if num_of_children > 1 then
			build_choices(response_id, node.props)
			warn(`completed creating choices... verify it first`)
		else
			return build_dialogue_tree(response_id, next_node)
		end
	elseif is_callback(node) then
		local callbackid = create_callback(parent, node.func)
		local num_of_children = #node.props
		if num_of_children > 1 then
			build_choices(callbackid, node.props)
		else
			return build_dialogue_tree(callbackid, next_node)
		end
	elseif is_if(node) then
		warn(`IF Dialgoue is not created yet`)
		return create_if(parent, node.check, node.success, node.failure)
	elseif is_goto(node) then
		error(`GOTO dialogue is not created yet`)
		return create_goto(parent, node.props)
	else
		error(`SHouldn't reach here`)
	end

	return parent
end

local function DIALOGUE(props: TABLE & { key: string })
	local root = world:entity() :: t.Entity

	-- Add some configuration here
	local _, next_props = next(props)
	local _ = build_dialogue_tree(root, next_props)

	return root
end

return {
	DIALOGUE = DIALOGUE,
	GOTO = GOTO,
	CHOICE = CHOICE,
	RESPONSE = RESPONSE,
	CALLBACK = CALLBACK,
	IF = IF,
}
