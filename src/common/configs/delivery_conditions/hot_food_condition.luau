local ReplicatedStorage = game:GetService("ReplicatedStorage")

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local world = require(ReplicatedStorage.common.ecs.world)
-- local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)
local config_types = require(ReplicatedStorage.types.config_types)
-- local pair = jecs.pair

export type hot_foot_condition_t = {
	duration_to_cool_down: number,
}

local condition_name: types.rouber_delivery_conditions_t = "hot_food_condition"
local start_phase = c.PickupOrderPhase
local end_phase = c.DropOffOrderPhase

local condition_id = world:entity() :: types.Entity
world:add(condition_id, c.DeliveryOrderCondition)
world:add(condition_id, c.HotFoodCondition)
world:set(condition_id, c.Name, condition_name)
world:set(condition_id, p.EntityId(c.Start), start_phase)
world:set(condition_id, p.EntityId(c.End), end_phase)

local function create_condition_order(order_id: types.Entity)
	local id = world:entity() :: types.Entity

	world:set(id, c.Parent, order_id)
	world:add(id, condition_id)
	world:set(id, c.EntityId, condition_id)
	world:set(id, c.Timestamp, os.clock())
	world:set(id, p.Lifetime(c.WorkingAt), 2)
	world:add(id, c.DeliveryOrderCondition)
	-- world:add(order_id, pair(c.EntityId, id))
	return id
end

local function was_condition_successful(ticket_id: types.Entity)
	if world:has(ticket_id, c.Failure) then
		return false
	end

	if world:has(ticket_id, c.Success) then
		return true
	end

	local curr_t = world:get(ticket_id, p.Lifetime(c.WorkingAt))
	if curr_t == nil or curr_t <= 0 then
		return false
	end

	return true
end

local condition: config_types.rouber_delivery_conditions_config_t & hot_foot_condition_t = {
	name = condition_name,
	display_name = "Hot Food!",
	description = `Deliver Food before it cools down!`,
	entity_id = condition_id,

	start_phase = start_phase,
	end_phase = end_phase,
	duration_to_cool_down = 60 * 2.5,

	create_order_condition = create_condition_order,
	is_condition_successful = was_condition_successful,
}

return condition
