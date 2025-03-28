local ReplicatedStorage = game:GetService("ReplicatedStorage")
local basepartmap = require(ReplicatedStorage.client.store.basepartmap)
local jecs = require(ReplicatedStorage.pkg.jecs)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local gizmo = require(ReplicatedStorage.common.utility.gizmo)
local phases = require(ReplicatedStorage.common.ecs.phases)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function filter_hit_parts(hit_parts: { BasePart })
	local set = {} :: { [BasePart]: true }
	local filtered = {}

	for _, part in hit_parts do
		if set[part] then
			continue
		end
		local id = basepartmap[part]

		if not id then
			continue
		end

		set[part] = true
		table.insert(filtered, part)
	end

	return filtered
end

local function find_closest_part(curr_pos: vector, hit_parts: { BasePart })
	-- It is guaranteed that min_part won't end up being nil. This is because if the hit_parts is
	-- empty, we already terminate before we reach this point
	local min_dist = math.huge
	local min_part = nil

	for i, part in hit_parts do
		local dest_pos = part.Position :: never
		local magnitude = vector.magnitude(curr_pos - dest_pos)

		if magnitude < min_dist then
			min_dist = magnitude
			min_part = part
		end
	end

	return min_part, min_dist
end

local function update_dialogue_proximity(
	hit_parts: { BasePart },
	min_part: BasePart,
	min_dist: number
)
	local dialogue_proximity = {} :: { types.DialogueProximityDetails }
	for _, part in hit_parts do
		local id = basepartmap[part]
		local dialogue_details = world:get(id, c.HasDialogue)

		if not dialogue_details then
			continue
		end

		local dialogue_initial_text = dialogue_details.initial_text
		local dialogue_activate_dist = dialogue_details.trigger_distance
		local dialogue_id_str = dialogue_details.dialogue_id
		--TODO: WE should do a table lookup here of [string]: entity
		local dialogue_id = dialogue_id_str :: never

		-- if it isn't equal to the min_part, then we only display the generic one
		local proximity_details: types.DialogueProximityDetails = {
			adornee = part,
			dialogue_id = id,
			proximity_text = dialogue_initial_text,
		}

		-- If it is min_part, then we do additional activate check
		if part == min_part then
			if min_dist <= dialogue_activate_dist then
				local parent = part:FindFirstAncestorOfClass("Model") :: Model
				uistore.ActiveDialogueProximity(id)
				uistore.ActiveDialgoueModel(parent)
			else
				uistore.ActiveDialogueProximity(nil)
				uistore.ActiveDialgoueModel(nil)
			end
		end

		table.insert(dialogue_proximity, proximity_details)
	end

	uistore.DialogueProximity(dialogue_proximity)
end

local function update_door_proximity(hit_parts: { BasePart }, min_part: BasePart, min_dist: number)
	local door_proximity = {} :: { types.DoorProximityDetails }

	for _, part in hit_parts do
		local id = basepartmap[part]
		local is_doormat_zone = world:has(id, c.DoormatZone)
		if not is_doormat_zone then
			continue
		end

		local parent = world:parent(id)
		assert(parent ~= nil, "Parent must exist for all doormat zones")
		local name = world:get(parent, c.Name)
		assert(name, `Name is required for every building so we can use it for proximity text`)
		local is_exterior = world:has(parent, c.Exterior)
		local details: types.DoorProximityDetails = {
			adornee = part,
			exterior = is_exterior,
			promptid = id,
			proximity_text = name,
		}
		table.insert(door_proximity, details)

		if part == min_part then
			--//TODO: tbh, we could probably store the active radius somewhere in our components
			-- but for now, im just using 8 cuz i thin our doormat is like 8x8? or supposed to at least LOL
			if min_dist <= 8 then
				uistore.ActiveProximity(id)
			else
				uistore.ActiveProximity(nil)
			end
		end
	end

	uistore.DoorProximity(door_proximity)
end

local cached = world
	:query(c.OverParams, c.PrimaryPart, c.Radius)
	:with(c.Client)
	:without(c.IsCutscenePlaying)
	:cached()
local function system()
	local it = cached:iter()
	local e, params, hrp, radius = it()
	if not e then
		return
	end

	radius *= 5
	local current_pos = (hrp.Position :: never) :: vector
	local unfiltered_result = workspace:GetPartBoundsInRadius(current_pos, radius, params)
	local filtered = filter_hit_parts(unfiltered_result)

	if #filtered == 0 then
		uistore.ActiveDialogueProximity(nil)
		uistore.ActiveProximity(nil)
		uistore.ActiveDialgoueModel(nil)
		uistore.DoorProximity({})
		uistore.DialogueProximity({})
		return
	end

	local min_part, min_dist = find_closest_part(current_pos, filtered)

	update_dialogue_proximity(filtered, min_part, min_dist)
	update_door_proximity(filtered, min_part, min_dist)
end

return {
	name = script.Name,
	system = system,
	phase = phases.PreUpdate,
	runConditions = {},
}
