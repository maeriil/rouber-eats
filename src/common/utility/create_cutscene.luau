local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local t = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)

local function is_scene(v: any)
	return type(v) == "table" and v._scene
end

type TABLE = { { t.Entity } }

local function CUTSCENE(props: TABLE)
	local scene_list = {}

	for i, scene in ipairs(props) do
		if not is_scene(scene) then
			error(`Passed an unknown datatype to the Cutscene, {scene}`)
		end

		local action_list = {} :: { t.Entity }
		for _, action in ipairs(scene) do
			table.insert(action_list, action)
		end

		table.insert(scene_list, action_list)
	end

	local cutscene = world:entity()
	world:set(cutscene, components.Cutscene, {
		cutscene = scene_list,
		curr_scene_id = 0,
		is_scene_complete = true,
	})
end

local function SCENE(props: { [number]: t.Entity })
	return {
		_scene = true,
		props = props,
	}
end

local function action<T...>(callback: (T...) -> t.Entity, ...: T...)
	return callback(...)
end

return {
	CUTSCENE = CUTSCENE,
	SCENE = SCENE,
	action = action,
}
