-- stylua: ignore start
local ReplicatedStorage          = game:GetService("ReplicatedStorage")
local jecs                       = require(ReplicatedStorage.pkg.jecs)
local phases                     = require(ReplicatedStorage.common.ecs.phases)
local delete_invalid_order_event = require(ReplicatedStorage.common.events.order.delete_invalid_order_event)
local update_order_dest_event    = require(ReplicatedStorage.common.events.order.update_order_dest_event)

local c                          = require(ReplicatedStorage.common.ecs.components)
local t                          = require(ReplicatedStorage.types)
local pair                       = jecs.pair
local world                      = require(ReplicatedStorage.common.ecs.world)
local __                         = jecs.Wildcard
-- stylua: ignore end

local invalid_vacant_query = world:query(c.DeliveryOrderDetails):with(c.Vacant, c.Invalid):cached()
local function delete_invalid_vacant_orders()
	for order_id, details in invalid_vacant_query:iter() do
		local client_id = world:target(order_id, c.Client) :: t.Entity
		local client = world:exists_get(client_id, c.Client)

		delete_invalid_order_event.to_client(client, order_id :: t.Entity)
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
		for order_id in world:targets(land_id, c.HasOrderToBeDelivered) do
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
			update_order_dest_event.to_client(client, order_id :: t.Entity, residence_id :: t.Entity)
		end

		-- for_each_target(land_id, c.HasOrderToBeDelivered, function(order_id)
		-- 	-- local order_details = world:exists_get(order_id, c.DeliveryOrderDetails)
		-- 	-- local client_id = world:target(order_id, c.Client)

		-- 	-- if client_id == nil then
		-- 	-- 	warn(`Inside cleanup_invalid_orders... How do we even reach this point??? Investigate!`)
		-- 	-- 	warn(`We will just mark it as vacant and move on for now ig...`)
		-- 	-- 	world:add(order_id, c.Vacant)
		-- 	-- 	world:remove(land_id, pair(c.HasOrderToBeDelivered, order_id))
		-- 	-- 	return
		-- 	-- end

		-- 	-- local client = world:exists_get(client_id, c.Client)
		-- 	-- order_details.destination_id = residence_id
		-- 	-- update_order_dest_event.to_client(client, order_id :: t.Entity, residence_id :: t.Entity)
		-- end)
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
