-- stylua: ignore start
local ReplicatedStorage          = game:GetService("ReplicatedStorage")
local ServerScriptService        = game:GetService("ServerScriptService")

local restaurant = require(ReplicatedStorage.common.configs.restaurant)
local update_delivery_conditions = require(ServerScriptService.server.server_utils.update_delivery_conditions)
local jecs                       = require(ReplicatedStorage.pkg.jecs)
local phases                     = require(ReplicatedStorage.common.ecs.phases)
local playerstore                = require(ServerScriptService.server.store.playerstore)
local try_pickup_order_event     = require(ReplicatedStorage.common.events.order.try_pickup_order_event)

local c                          = require(ReplicatedStorage.common.ecs.components)
local ref                        = require(ReplicatedStorage.common.ecs.ref)
local t                          = require(ReplicatedStorage.types)
local world                      = require(ReplicatedStorage.common.ecs.world)
local __                         = jecs.Wildcard
-- stylua: ignore end

--[[
	This one below is for when a player reaches restaurant and they are trying to pickup their
	order. They will send the restuarant id most likely, and then from our end, we will iterate over
	all the orders within this restaurant and mark its status as in progress. If we found some result
	we fire back a response saying we picked it up, if we didn't we need to send the failure status.
	While this is happening the client needs to yield. How will they yield tho....?
]]
local function end_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
	try_pickup_order_event.to_client(player, {
		success = false,
		error_msg = message,
	})
end

local function try_pickup_order_request(player: Player, restaurant_id: string?)
	local player_id = ref(player)
	local config = restaurant[restaurant_id]

	if config == nil then
		end_with_failure(player, `Could not find a valid restaurant`)
		return
	end
	-- if
	-- 	not restaurant_id
	-- 	or not world:contains(restaurant_id)
	-- 	or not world:has(restaurant_id, c.Restaurant)
	-- then
	-- 	end_with_failure(player, `Could not find a valid restaurant. Ignoring your request`)
	-- 	return
	-- end

	if not world:has(player_id, c.IsWorking) then
		end_with_failure(
			player,
			`You are currently not working! There is no way you have accepted orders!`
		)
		return
	end

	local store = playerstore[player]

	for idx, my_order_id in store.my_accepted_orders do
		local details = world:exists_get(my_order_id, c.DeliveryOrderDetails)

		if details.restaurant_id ~= restaurant_id then
			continue
		end

		-- Move this from the accepted array to picked up array now
		table.remove(store.my_accepted_orders, idx)
		table.insert(store.my_pickedup_orders, my_order_id)
		-- Mark this order as being processed
		world:add(my_order_id, c.WorkingAt)

		try_pickup_order_event.to_client(player, {
			success = true,
			error_msg = ``,
		})

		--[[
			NOTE: We didn't do Delivery conditions creation here. This is a design choice!
			we should only stop the conditions that were meant to be picked up. But after that
			the player has a choice on what they want to do. So we should be creating it during that
			phase
		]]
		local order_id = my_order_id :: t.Entity --//TODO: luau and jecs
		update_delivery_conditions(c.PickupOrderPhase, player, order_id)

		-- NOTE: we are returning here cuz we only want to process an order at a time
		-- this is a design choice which idk if i will change in future
		return
	end

	-- If we do reach here, then it means we did not find it.. So mark it as failed
	end_with_failure(player, `You do not have any orders to pickup!`)
	return
end

local from_client_event = try_pickup_order_event.from_client()

local function system()
	for a, player, restaurant_name in from_client_event.iter() do
		try_pickup_order_request(player, restaurant_name)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
