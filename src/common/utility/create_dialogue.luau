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

local build_dialogue_tree: (parent: t.Entity, node: TABLE, key_map: { [string]: t.Entity }) -> t.Entity
local build_choices: (parent: t.Entity, node: TABLE, key_map: { [string]: t.Entity }) -> ()

local function create_choicecontainer(parent, key_map)
	local container_id = world:entity() :: t.Entity
	world:set(container_id, c.Parent, parent)
	world:add(parent, pair(c.Next, container_id))
	world:add(container_id, c.DialogueChoiceContainer)

	return container_id
end

local function create_choice(parent, t, key_map)
	local choice_id = world:entity() :: t.Entity
	world:set(choice_id, c.Parent, parent)
	world:add(choice_id, c.DialogueChoice)
	world:set(choice_id, c.DialogueText, t.props.text)
	world:add(parent, pair(c.Next, choice_id))
	return choice_id
end

local function create_response(parent: t.Entity, props, key_map)
	local dialogue_text = props.text
	local key = props.key
	local response_id = world:entity() :: t.Entity

	if key then
		key_map[key] = response_id
	end

	world:add(parent, pair(c.Next, response_id))
	world:add(response_id, c.DialogueResponse)
	world:set(response_id, c.Parent, parent)
	world:set(response_id, c.DialogueText, dialogue_text)

	return response_id
end

local function create_if(parent, check_function, success, failure, key_map)
	-- I think this one might have bugs
	local if_id = world:entity() :: t.Entity
	world:add(parent, pair(c.Next, if_id))
	world:set(if_id, c.Parent, parent)
	world:set(if_id, c.DialogueIf, check_function)
	world:set(if_id, c.DialogueText, "todo... add condition text")

	local success_id = world:entity() :: t.Entity
	world:add(success_id, c.DialogueSuccess)
	if #success > 1 then
		build_choices(success_id, success, key_map)
	else
		local _, next_node = next(success)
		build_dialogue_tree(success_id, next_node, key_map)
	end
	world:add(if_id, pair(c.DialogueSuccess, success_id))

	local failure_id = world:entity() :: t.Entity
	world:add(failure_id, c.DialogueFailure)
	if #failure > 1 then
		build_choices(failure_id, failure, key_map)
	else
		local _, next_node = next(failure)
		build_dialogue_tree(failure_id, next_node, key_map)
	end
	world:add(if_id, pair(c.DialogueFailure, failure_id))

	return if_id
end

local function create_callback(parent: t.Entity, callback: () -> (), key_map)
	local callback_id = world:entity() :: t.Entity
	world:set(callback_id, c.Parent, parent)
	world:add(parent, pair(c.Next, callback_id))
	world:set(callback_id, c.DialogueCallback, callback)

	return callback_id
end

local function create_goto(parent, props, key_map)
	local goto_id = world:entity() :: t.Entity
	local key = props.key
	local next_id = key_map[key]
	if next_id == nil then
		error(`Could not find the key speciifed, verify that it exists`)
	end

	world:set(goto_id, c.Parent, parent)
	world:add(goto_id, c.DialogueGoto)
	world:add(goto_id, pair(c.Next, next_id))
	world:add(parent, pair(c.Next, goto_id))
	return goto_id

	-- This is typically the leaf node
end

-- WE will need to create other things like create_response etc as well
function build_choices(parent: t.Entity, props: TABLE, key_map)
	local container_id = create_choicecontainer(parent, key_map)
	for _, choice in ipairs(props) do
		local choice_id = create_choice(container_id, choice, key_map)
		local num_of_children = #choice.props

		if num_of_children > 1 then
			build_choices(choice_id, choice.props, key_map)
		else
			local _, choice_nextnode = next(choice.props)
			build_dialogue_tree(choice_id, choice_nextnode, key_map)
		end
	end

	return
end

function build_dialogue_tree(parent, node, key_map)
	if not node or typeof(node) == "function" or not node.props then
		return parent
	end

	local _, next_node = next(node.props)
	if is_response(node) then
		local response_id = create_response(parent, node.props, key_map)

		local num_of_children = #node.props
		if num_of_children > 1 then
			build_choices(response_id, node.props, key_map)
		else
			return build_dialogue_tree(response_id, next_node, key_map)
		end
	elseif is_callback(node) then
		local callbackid = create_callback(parent, node.func, key_map)
		local num_of_children = #node.props
		if num_of_children > 1 then
			build_choices(callbackid, node.props, key_map)
		else
			return build_dialogue_tree(callbackid, next_node, key_map)
		end
	elseif is_if(node) then
		return create_if(parent, node.check, node.success, node.failure, key_map)
	elseif is_goto(node) then
		return create_goto(parent, node.props, key_map)
	else
		error(`SHouldn't reach here`)
	end

	return parent
end

local function DIALOGUE(props: TABLE & { key: string })
	local root = world:entity() :: t.Entity
	local key_map = {} :: { [string]: t.Entity }

	-- Add some configuration here
	local _, next_props = next(props)
	local _ = build_dialogue_tree(root, next_props, key_map)

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
