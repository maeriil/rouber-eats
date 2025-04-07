local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playerstore = require(ServerScriptService.server.store.playerstore)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local pickup_order_event = require(ReplicatedStorage.common.events.restaurant.pickup_order_event)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
	This one below is for when a player reaches restaurant and they are trying to pickup their
	order. They will send the restuarant id most likely, and then from our end, we will iterate over
	all the orders within this restaurant and mark its status as in progress. If we found some result
	we fire back a response saying we picked it up, if we didn't we need to send the failure status.
	While this is happening the client needs to yield. How will they yield tho....?
]]
local function end_with_failure(player: Player, message: string)
	warn(`The server failed, with message = {message}`)
	pickup_order_event.to_client(player, {
		success = false,
		error_msg = message,
	})
end

local function try_pickup_order_request(player: Player, restaurant_id: t.Entity?)
	local player_id = ref(player)
	print(`REstaurant id we got was {restaurant_id}`)
	if
		not restaurant_id
		or not world:contains(restaurant_id)
		or not world:has(restaurant_id, c.Restaurant)
	then
		end_with_failure(player, `Could not find a valid restaurant. Ignoring your request`)
		return
	end

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
		warn(`Found a valid order!, adding details..`)

		-- If it is, here, we need to move it to picked up, then we will let client know
		-- it was valid
		local target_house_id = details.destination_id

		-- Move this from the accepted array to picked up array now
		table.remove(store.my_accepted_orders, idx)
		table.insert(store.my_pickedup_orders, my_order_id)
		warn(`Okay we can go and pickup order for the house {world:get(target_house_id, c.Name)}`)

		-- Mark this order as being processed
		world:add(my_order_id, c.WorkingAt)

		pickup_order_event.to_client(player, {
			success = true,
			error_msg = ``,
		})
		return
	end

	-- If we do reach here, then it means we did not find it.. So mark it as failed

	warn(`found no order... ending with failure and sending to client..`)
	end_with_failure(player, `You do not have any orders to pickup!`)
	return
end

local from_client_event = pickup_order_event.from_client()

local function system()
	for a, player, restaurant_id in from_client_event.iter() do
		try_pickup_order_request(player, restaurant_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
