local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local pairs = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

type TABLE = { [any]: any }

local function is_choice(v: any)
	return type(v) == "table" and v._choice
end

local function is_callback(v: any)
	return type(v) == "table" and v._callback
end

local function is_goto(v: any)
	return type(v) == "table" and v._goto
end

local function is_condition(v: any)
	return type(v) == "table" and v._condition
end

function setup_choice(
	props: {
		usertext: string,
		response: string,
		key: string?,
	} & TABLE,
	parent: Entity,
	fallback: boolean?
)
	local COMPONENT = if fallback then c.FallbackChoice else c.Choice

	local choice = world:entity() :: Entity
	world:add(parent, pair(COMPONENT, choice))
	world:add(choice, pairs.childof(parent))
	world:add(choice, COMPONENT)
	world:set(choice, c.DialogueDetails, {
		response = props.response,
		usertext = props.usertext,
	})
	world:set(choice, c.DialogueId, props.key or "")

	build_dialouge_tree(props, choice)
end

function setup_condition(
	props: { cond: { () -> boolean }, Fallback: TABLE } & TABLE,
	parent: Entity
)
	world:set(parent, c.DialogueCondition, props.check)

	for i, v in ipairs(props.success) do
		setup_choice(v.props, parent)
	end
	for i, v in ipairs(props.failure) do
		setup_choice(v.props, parent, true)
	end
end

function setup_callback(props: TABLE, parent: Entity)
	local callbacks = {}

	for i, v in ipairs(props) do
		table.insert(callbacks, v :: () -> ())
	end

	world:set(parent, c.DialogueCallbacks, callbacks)
end

function setup_goto(
	props: TABLE & {
		key: string,
	},
	parent: Entity
)
	local target_key = props.key
	local current = parent

	while current do
		local dialogue_id = world:get(current, c.DialogueId)
		if dialogue_id == target_key then
			world:set(parent, c.GoTo, current)
			return
		end
		current = world:parent(current) :: Entity
	end
	error(`GoTo target {target_key} not found for {parent}`)
end

function build_dialouge_tree(props: TABLE, parent: Entity)
	if #props == 0 then
		return
	end

	for i, v in ipairs(props) do
		if is_choice(v) then
			setup_choice(v.props, parent)
		elseif is_condition(v) then
			setup_condition(v, parent)
		elseif is_callback(v) then
			setup_callback(v.props, parent)
		elseif is_goto(v) then
			setup_goto(v.props, parent)
		end
	end
end

local function DIALOGUE(props: {
	npc: Model,
	initial_text: string,
	key: string?,
} & TABLE)
	local e = world:entity() :: Entity
	local author = props.npc.Name
	local parent = ref(props.npc)

	world:add(parent, pair(c.DialogueOf, e))
	world:add(e, pairs.childof(parent))
	world:set(e, c.Dialogue, {
		author = author,
		initial_text = props.initial_text,
		trigger_distance = 10,
		conversation_distance = 10,
	})
	world:set(e, c.DialogueId, props.key or "")

	build_dialouge_tree(props, e)
end

local function CHOICE(props: TABLE)
	return {
		_choice = true,
		props = props,
	}
end

local function CALLBACK(props: TABLE)
	return {
		_callback = true,
		props = props,
	}
end

local function GOTO(props: TABLE)
	return {
		_goto = true,
		props = props,
	}
end

local function CONDITION(check_func)
	return function(props: { SUCCESS: TABLE, FAILURE: TABLE })
		return {
			_condition = true,
			check = check_func,
			success = props.SUCCESS,
			failure = props.FAILURE,
		}
	end
end

return {
	DIALOGUE = DIALOGUE,
	CHOICE = CHOICE,
	CALLBACK = CALLBACK,
	GOTO = GOTO,
	CONDITION = CONDITION,
}
