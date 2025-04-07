local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function delete_invalid_order()
	for _, _server_order_id in clientevents.RouberOrders.delete_order.iter() do
		local order_id = blink_conv.as_entity(_server_order_id)

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

local function update_order()
	for _, _server_order_id, _new_house_id in clientevents.RouberOrders.update_order_address.iter() do
		local server_order_id = blink_conv.as_entity(_server_order_id)
		local new_server_house_id = blink_conv.as_entity(_new_house_id)

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
