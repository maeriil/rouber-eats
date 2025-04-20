local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local start_delivery_conditions =
	require(ServerScriptService.server.server_utils.start_delivery_conditions)
local update_delivery_conditions =
	require(ServerScriptService.server.server_utils.update_delivery_conditions)
local delivery_conditions = require(ReplicatedStorage.common.configs.delivery_conditions)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerstore = require(ServerScriptService.server.store.playerstore)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local try_accept_order_event = require(ReplicatedStorage.common.events.order.try_accept_order_event)
local __ = jecs.Wildcard

--[[
	This one below is for when player tries to accept an order in restuarant but the order fails
	to be accepted. It could be for many reasons actually
		1. Order is expired or doesn't exist anymore
		2. Order is already claimed by someone else
		3. Player has already accepted the same order

  TODO: We also need to kinda display them to the UI
]]
local function end_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
	try_accept_order_event.to_client(player, {
		error_msg = message,
		success = false,
	}, -1 :: never)
end

local function try_accept_order_request(player: Player, order_id: t.Entity?)
	local player_id = ref(player)
	if order_id == nil then
		end_with_failure(
			player,
			`Sent an undefined order_id to process. Request will be dropped. This should never happen however`
		)
		return
	end

	if not world:contains(order_id) or not world:has(order_id, c.DeliveryOrderDetails) then
		end_with_failure(
			player,
			`The delivery order {order_id} does not exist. It may have never existed or expired`
		)
		return
	end

	--[[
      TODO: sometimes an order might be claimed by multiple people. that is, anyone can
      claim this order (consider event based orders). In this case, the following check
      needs to be tweaked up a bit
    ]]

	local another_userid = world:get(order_id, p.EntityId(c.ClaimedBy))
	if another_userid ~= nil and another_userid ~= player_id then
		end_with_failure(player, `Another user has already claimed this order. Aborting request`)
		return
	end

	if another_userid == player_id then
		end_with_failure(player, `You have already accepted the order!`)
		return
	end

	-- Now, verify that the player actually owns this order
	local livestore = playerstore[player]
	local my_orders = livestore.my_orders
	local my_conditions = livestore.my_active_delivery_conditions

	local order_id_index = table.find(my_orders, order_id)
	if order_id_index == nil then
		local msg = `You do not have the order id you think you have!`
		warn(`player {player.Name}, {msg}`)
		end_with_failure(player, `You do not have the order id you think you have!`)
		return
	end

	if not world:has(player_id, c.IsWorking) then
		warn(`Player is not working atm, changing the working status to working`)
		world:add(player_id, c.IsWorking)
	end

	-- We don't need this i dont think
	world:set(order_id, p.EntityId(c.ClaimedBy), player_id)
	world:remove(order_id, c.Vacant)

	table.remove(livestore.my_orders, order_id_index)
	table.insert(livestore.my_accepted_orders, order_id)
	-- serverevents.RouberOrders.accept_order_response.fire_all(true, blink_conv.from_entity(order_id))
	try_accept_order_event.to_client(player, {
		success = true,
		error_msg = "",
	}, order_id)

	-- Determine if the order has conditions and check to see if they belong in the category
	update_delivery_conditions(c.AcceptOrderPhase, player, order_id)
	start_delivery_conditions(c.AcceptOrderPhase, player, order_id)

	-- local order_details = world:exists_get(order_id, c.DeliveryOrderDetails)
	-- for _, condition_id in order_details.conditions_list_id do
	-- 	-- get the condition details
	-- 	warn(`Found some condition related stuff...`)
	-- 	local condition_name: t.rouber_delivery_conditions_t =
	-- 		world:exists_get(condition_id, c.Name) :: t.rouber_delivery_conditions_t
	-- 	local details = delivery_conditions[condition_name]

	-- 	if details.start_phase == c.AcceptOrderPhase then
	-- 		warn(`The starting phase is accept.. So we are starting the condition`)
	-- 		local ticket_id = details.create_order_condition(order_id)
	-- 		table.insert(my_conditions, ticket_id)
	-- 	end
	-- end
end

local from_client_attmepts = try_accept_order_event.from_client()
local function system()
	for _, player, order_id in from_client_attmepts.iter() do
		try_accept_order_request(player, order_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
