local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerstore = require(ServerScriptService.server.store.playerstore)
local serverevents = require(ServerScriptService.server.serverevents)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
	This one below is for when player tries to accept an order in restuarant but the order fails
	to be accepted. It could be for many reasons actually
		1. Order is expired or doesn't exist anymore
		2. Order is already claimed by someone else
		3. Player has already accepted the same order
]]
local function end_accept_request_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
	return serverevents.RouberOrders.accept_order_response.fire(player, false, -1, message)
end

local function accept_order_request()
	for _, player, _order_id in serverevents.RouberOrders.i_want_to_accept_order.iter() do
		local player_id = ref(player)
		local order_id = blink_conv.as_entity(_order_id)
		if order_id == nil then
			end_accept_request_with_failure(
				player,
				`Sent an undefined order_id to process. Request will be dropped. This should never happen however`
			)
			continue
		end

		if not world:contains(order_id) or not world:has(order_id, c.DeliveryOrderDetails) then
			end_accept_request_with_failure(
				player,
				`The delivery order {order_id} does not exist. It may have never existed or expired`
			)
			continue
		end

		--[[
      TODO: sometimes an order might be claimed by multiple people. that is, anyone can
      claim this order (consider event based orders). In this case, the following check
      needs to be tweaked up a bit
    ]]

		-- local details =
		-- 	world:get(order_id, c.DeliveryOrderDetails) :: typeof(c.DeliveryOrderDetails.__T)
		local another_userid = world:get(order_id, pair(c.EntityId, c.Claim))
		if another_userid ~= nil and another_userid ~= player_id then
			end_accept_request_with_failure(
				player,
				`Another user has already claimed this order. Aborting request`
			)
			continue
		end

		if another_userid == player_id then
			end_accept_request_with_failure(player, `You have already accepted the order!`)
			continue
		end

		if not world:has(player_id, c.IsWorking) then
			warn(`Player is not working atm, changing the working status to working`)
			world:add(player_id, c.IsWorking)
		end

		world:set(order_id, pair(c.EntityId, c.Claim), player_id)

		-- local destination_id = details.destination_id
		-- local restaurant_id = details.restaurant_id
		local e = world:entity() :: t.Entity
		world:add(e, pair(c.WorkingAt, order_id))
		world:add(e, p.childof(player_id))
		-- idk if we need this below tbh... we can just get the delivery details?
		-- world:set(e, pair(c.EntityId, c.House), destination_id)
		-- world:set(e, pair(c.EntityId, c.Restaurant), restaurant_id)
		world:set(e, c.DeliveryOrderStatus, "NotPickedUp")

		local store = playerstore[player]
		table.insert(store.my_orders, e)
		warn(`completed acceptped the order... Player can go pickup from restaurant now`)

		serverevents.RouberOrders.accept_order_response.fire_all(true, blink_conv.from_entity(order_id))
	end
end

--[[
	This one below is for when a player reaches restaurant and they are trying to pickup their
	order. They will send the restuarant id most likely, and then from our end, we will iterate over
	all the orders within this restaurant and mark its status as in progress. If we found some result
	we fire back a response saying we picked it up, if we didn't we need to send the failure status.
	While this is happening the client needs to yield. How will they yield tho....?
]]
local function end_pickup_request_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
	return serverevents.RouberOrders.pickup_order_response.fire(player, false, -1, message)
end

local function pickup_order_request()
	for _, player, _restaurant_id in serverevents.RouberOrders.i_want_to_pickup_order.iter() do
		warn(`Client wants to pickup order request?? okay... lets verify it..`)

		local player_id = ref(player)
		local restaurant_id = blink_conv.as_entity(_restaurant_id)

		if not world:contains(restaurant_id) or not world:has(restaurant_id, c.Restaurant) then
			end_pickup_request_with_failure(
				player,
				`Could not find a valid restaurant. Ignoring your request`
			)
			continue
		end

		if not world:has(player_id, c.IsWorking) then
			end_pickup_request_with_failure(
				player,
				`You are curren't not working! There is no way you have accepted orders!`
			)
			continue
		end

		--[[
			Grab all the orders created by this player, and iterate them all. If we find something
			we will have success status, if we don,t we have failure status
		]]
		local store = playerstore[player]
		local found_once = false
		local target_house_id = nil :: t.Entity?

		for _, my_order_id in store.my_orders do
			local order_info_id = world:target(my_order_id, c.WorkingAt) :: t.Entity
			local details = world:exists_get(order_info_id, c.DeliveryOrderDetails)
			local status = world:exists_get(my_order_id, c.DeliveryOrderStatus)

			if details.restaurant_id == restaurant_id and status == "NotPickedUp" then
				world:set(my_order_id, c.DeliveryOrderStatus, "PickedUp")
				target_house_id = details.destination_id

				found_once = true
			end
		end

		if not found_once then
			end_pickup_request_with_failure(player, `You do not have any orders to pickup!`)
			continue
		end

		local house_id = target_house_id :: t.Entity

		warn(`Okay we can go and pickup order for the house {world:get(house_id, c.Name)}`)

		serverevents.RouberOrders.pickup_order_response.fire(
			player,
			true,
			blink_conv.from_entity(house_id)
		)
	end
end

local function select_order_choice() end

local function complete_order_request()
	for _, player, _house_id in serverevents.RouberOrders.i_want_to_complete_order.iter() do
		warn(`complete order request found...!`)
		local player_id = ref(player)
		local house_id = blink_conv.as_entity(_house_id)

		if not world:contains(house_id) or not world:has(house_id, c.House) then
			warn(`The user passed an invalid id to the server. Ignoring the request`)
			continue
		end

		if not world:has(player_id, c.IsWorking) then
			warn(`Player is not working atm, so they cant possible be delivering order!`)
			continue
		end

		local order_list = playerstore[player].my_orders
		local reward_amount = 0
		local valid_order_id = nil
		for _, my_order_id in order_list do
			local order_info_id = world:target(my_order_id, c.WorkingAt) :: t.Entity
			local details, coins = world:exists_get(order_info_id, c.DeliveryOrderDetails, c.Coins)
			local status = world:exists_get(my_order_id, c.DeliveryOrderStatus)

			if details.destination_id == house_id and status == "PickedUp" then
				--//TODO WE meed to add another check here confirming that we actually picked Deliver
				valid_order_id = my_order_id
				reward_amount = coins
				break
			end
		end

		if valid_order_id == nil then
			warn(`Could not find a proper order if for the provided house id. Ignoring request`)
			continue
		end

		-- We might need to do additional checks here
		--//TODO: award player with some currency now
		--//TODO: Do we delete the order id? Or what do we do with it?

		warn(`WE ARE MARKING IT AS DELIVERED!!!`)
		world:set(valid_order_id, c.DeliveryOrderStatus, "Delivered")
		serverevents.Building.add_cutscene_to_house.fire(player, _house_id)
		warn(`increasing the coints!`)
		world:set(player_id, p.IncreaseCoins, reward_amount)

		--//TODO now, remove the order from the player
		-- we should probaly just do this inside the if statemnet tbh
	end
end

local function system()
	accept_order_request()
	pickup_order_request()
	select_order_choice()
	complete_order_request()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
