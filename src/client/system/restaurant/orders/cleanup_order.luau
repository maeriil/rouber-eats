-- stylua: ignore start
local ReplicatedStorage          = game:GetService("ReplicatedStorage")
local phases                     = require(ReplicatedStorage.common.ecs.phases)
local server_id_map              = require(ReplicatedStorage.client.store.server_id_map)
local delete_invalid_order_event = require(ReplicatedStorage.common.events.order.delete_invalid_order_event)
local update_order_dest_event    = require(ReplicatedStorage.common.events.order.update_order_dest_event)

local c                          = require(ReplicatedStorage.common.ecs.components)
local world                      = require(ReplicatedStorage.common.ecs.world)
-- stylua: ignore end

local delete_invalid_orders_list = delete_invalid_order_event.from_server()
local function delete_invalid_order()
	for _, order_id in delete_invalid_orders_list.iter() do
		local client_order_id = server_id_map.order_map[order_id]
		if client_order_id == nil then
			warn(
				`Hmm. Somehow we are firing event to a client who doesn't have this order. We should never reach here tbh..`
			)
			continue
		end

		world:delete(client_order_id)
		server_id_map.order_map[order_id] = nil
	end
end

local adjust_order_dest_list = update_order_dest_event.from_server()
local function update_order()
	for _, server_order_id, new_server_house_id in adjust_order_dest_list.iter() do
		local client_order_id = server_id_map.order_map[server_order_id]
		if client_order_id == nil then
			warn(
				`Hmm. Somehow we are firing event to a client who doesn't have this order. We should never reach here tbh..`
			)
			continue
		end

		local client_house_id = server_id_map.residence_map[new_server_house_id]
		if client_house_id == nil then
			warn(
				`Hmm. The client house id is nil so that means the server house isn't setup for this player??`
			)
			warn(`this makes no sense tbh... investigate, for now code will ignore the request`)
			continue
		end

		local details = world:exists_get(client_order_id, c.DeliveryOrderDetails)
		details.destination_id = client_house_id
	end
end

local function system()
	delete_invalid_order()
	update_order()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
