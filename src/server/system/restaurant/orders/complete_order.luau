-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local start_delivery_conditions = require(ServerScriptService.server.server_utils.start_delivery_conditions)
local update_delivery_conditions = require(ServerScriptService.server.server_utils.update_delivery_conditions)
local serverevents = require(ServerScriptService.server.serverevents)
local poses = require(ReplicatedStorage.common.configs.poses)
local playerstore = require(ServerScriptService.server.store.playerstore)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local invoke_complete_order_event = require(ReplicatedStorage.common.events.order.invoke_complete_order_event)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local tr = require(ReplicatedStorage.common.ecs.target)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard
-- stylua: ignore end

local function get_pose_adjustment(
	pose_kind: t.rouber_pose_t,
	preferred: typeof(c.PreferredPoseCategory.__T)
)
	local pose_details = poses[pose_kind]
	local category = pose_details.category

	if table.find(preferred.likes, category) then
		return 1
	elseif table.find(preferred.dislikes, category) then
		return -1
	end

	return 0
end

local function get_condition_adjustment()
	return 0
end

local function complete_order(player: Player, house_id: t.Entity?)
	if not house_id or not world:contains(house_id) then
		return
	end

	local player_id = ref(player)
	local store = playerstore[player]
	local dropped_off_orders = store.my_orders_to_drop_off
	local my_rating = world:exists_get(player_id, c.Rating)

	--[[
    For each of the order, we will need to calculate teh following details

    1. final rating based on some formula
    2. final roubins based on some formula
    3. worry about mystery box later on
    4. all the conditions we have completed for the order

  ]]
	local total_net_ratings = 0
	local total_net_roubins = 0
	local conditions_completed = {}

	-- They must all be from same house_id
	for i = #dropped_off_orders, 1, -1 do
		local order_id = dropped_off_orders[i]

		update_delivery_conditions(c.CompleteOrderPhase, player, order_id)

		local details, base_rating_reward, base_roubins_reward, pose =
			world:exists_get(order_id, c.DeliveryOrderDetails, c.Rating, c.Roubins, c.Pose)

		local owner_id = world:exists_get(house_id, c.OccupiedByNPC)
			or world:exists_get(house_id, c.OccupiedByPlayer)
		local owner_preferences = world:exists_get(owner_id, c.PreferredPoseCategory)

		if details.destination_id ~= house_id then
			-- Idk how this even happens but return it tbh
			warn(`At least one of the orders does not match with the provided param, dropping request`)
			return
		end

		local pose_factor = get_pose_adjustment(pose, owner_preferences)
		local condition_factor = get_condition_adjustment()

		local pose_rating = pose_factor * 0.025
		local condition_rating = condition_factor * 0.18
		local rating_adjustment = 1 - ((my_rating + 0.00085) / 5)
		local final_rating = (base_rating_reward + pose_rating + condition_rating) * rating_adjustment
		warn(`final rating for the order is = {final_rating}`)

		local final_roubins = base_roubins_reward

		total_net_ratings += final_rating
		total_net_roubins += final_roubins

		serverevents.RouberOrders.delete_order.fire(player, order_id :: any)
		world:delete(order_id)
		dropped_off_orders[i] = nil
	end

	world:set(player_id, p.Increase(c.Rating), total_net_ratings)
	world:set(player_id, p.Increase(c.Roubins), total_net_roubins)

	invoke_complete_order_event.to_client(
		player,
		total_net_ratings,
		total_net_roubins,
		conditions_completed
	)
end

local invoke_order_complete = invoke_complete_order_event.from_client()
local function system()
	for _, player, house_id in invoke_order_complete.iter() do
		complete_order(player, house_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
