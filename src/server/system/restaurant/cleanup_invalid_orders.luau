local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local serverevents = require(ServerScriptService.server.serverevents)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local for_each_target = require(ReplicatedStorage.common.utility.for_each_target)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[

  We need to really verify this system more. Here is the scenario

  Game creates an order for house A.
  For some reason house A is deleted (either a player joins, or player leaves)
  Now the order is pointing towards an invalid House.


]]

local invalid_vacant_query = world:query(c.DeliveryOrderDetails):with(c.Vacant, c.Invalid):cached()
local function delete_invalid_vacant_orders()
	-- local players_who_completed_req = {}

	-- for client_id, client in world:query(c.Client):iter() do
	-- 	local config = playersetupconfig[client]

	-- 	if config and config.order_setup.client_completed then
	-- 		table.insert(players_who_completed_req, client)
	-- 	end
	-- end

	-- for order_id in invalid_vacant_query:iter() do
	-- 	warn(`Found an invalid order that is vacant. We will swiftly remove it from the world`)
	-- 	warn(`!!!=== sending it to `, players_who_completed_req)
	-- 	serverevents.RouberOrders.delete_order.fire_list(
	-- 		players_who_completed_req,
	-- 		blink_conv.from_entity(order_id)
	-- 	)

	-- 	world:delete(order_id)
	-- end

	for order_id, details in invalid_vacant_query:iter() do
		local client_id = world:target(order_id, c.Client) :: t.Entity
		local client = world:exists_get(client_id, c.Client)

		serverevents.RouberOrders.delete_order.fire(client, blink_conv.from_entity(order_id))

		world:delete(order_id)
	end
end

local invalid_nonvacant_query = world
	:query(c.Residence)
	:with(c.LandPlot, pair(c.HasOrderToBeDelivered, __))
	:without(c.Vacant)
	:cached()

local function update_nonvacant_invalid_orders()
	-- We should mark it with something here...?
	for land_id, residence_id in invalid_nonvacant_query:iter() do
		-- warn(`Found an invalid order that was pointing to existing house`)
		-- warn(`Since someone has accepted it, we should update their details`)
		-- warn(`!!!==========================================`)
		-- for_each_target(land_id, c.HasOrderToBeDelivered, function(order_id)
		-- 	local order_details = world:exists_get(order_id, c.DeliveryOrderDetails)
		-- 	local claimed_by = world:get(order_id, pair(c.EntityId, c.Claim))

		-- 	if claimed_by == nil then
		-- 		warn(`We found that the order is somehow claimed by no one anymore....`)
		-- 		warn(`This is kinda interesting.... We should investigate this more, for now we delete it`)
		-- 		world:add(order_id, c.Vacant)
		-- 		return
		-- 	end

		-- 	order_details.destination_id = residence_id :: t.Entity
		-- 	local player = world:exists_get(claimed_by, c.Client)

		-- 	local _new_house_id = blink_conv.from_entity(residence_id)
		-- 	local _order_id = blink_conv.from_entity(order_id)

		-- 	serverevents.RouberOrders.update_order_address.fire(player, _order_id, _new_house_id)
		-- end)

		-- error(`//TODO: We actually havent implemented this where an accepted order's residence changes`)

		for_each_target(land_id, c.HasOrderToBeDelivered, function(order_id)
			local order_details = world:exists_get(order_id, c.DeliveryOrderDetails)
			local client_id = world:target(order_id, c.Client)

			if client_id == nil then
				warn(`Inside cleanup_invalid_orders... How do we even reach this point??? Investigate!`)
				warn(`We will just mark it as vacant and move on for now ig...`)
				world:add(order_id, c.Vacant)
				world:remove(land_id, pair(c.HasOrderToBeDelivered, order_id))
				return
			end

			local client = world:exists_get(client_id, c.Client)
			order_details.destination_id = residence_id
			local _new_house_id = blink_conv.from_entity(residence_id)
			local _order_id = blink_conv.from_entity(order_id)

			serverevents.RouberOrders.update_order_address.fire(client, _order_id, _new_house_id)
		end)
	end
end

local function system()
	delete_invalid_vacant_orders()
	update_nonvacant_invalid_orders()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
