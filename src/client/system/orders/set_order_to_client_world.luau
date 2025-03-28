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
local remotes = require(ReplicatedStorage.types.remotes)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function find_valid_client_restaurant_id(server_id: t.Entity)
	local id = server_id_map.restaurant_map[server_id]

	assert(id ~= nil, `Restaurant ID must not be nil`)
	assert(world:contains(id), `Restaurant Id must exist in the world`)

	return id
end

local function find_valid_client_destination_id(server_id: t.Entity)
	local id = server_id_map.residence_map[server_id]

	assert(id ~= nil, `Residence ID must not be nil`)
	assert(world:contains(id), `Residence Id must exist in the world`)

	return id
end

local function add_order_to_world(_server_id: number, _details: remotes.RouberOrders_DeliveryType)
	local server_id = blink_conv.as_entity(_server_id)
	local restaurant_id = blink_conv.as_entity(_details.restaurant_id)
	local destination_id = blink_conv.as_entity(_details.destination_id)

	local client_restaurant_id = find_valid_client_restaurant_id(restaurant_id)
	local client_destination_id = find_valid_client_destination_id(destination_id)

	print(`client restaurant id = {client_restaurant_id}`)
	print(`server destination id = {client_destination_id}`)

	local server_food_list = _details.foods_list_id
	local server_cond_list = _details.conditions_list_id

	print(server_food_list)
	print(server_cond_list)

	local order_id = world:entity() :: t.Entity

	--//TODO : we need to convert the food into [Server]: Client map too
	local delivery_details = {
		restaurant_id = client_restaurant_id,
		destination_id = client_destination_id,
		foods_list_id = server_food_list :: never,
		conditions_list_id = server_cond_list :: never,
	}
	world:set(order_id, c.EntityId, server_id)
	world:set(order_id, c.DeliveryOrderDetails, delivery_details)
	world:add(order_id, c.Vacant)

	server_id_map.order_map[server_id] = order_id
end

local function create_order_to_world()
	for _, server_id_list, details_list in clientevents.RouberOrders.bulk_create_order.iter() do
		local n = #server_id_list
		warn(`Bulk creating {n} delivery orders in the client...`)
		for i = 1, n do
			local server_id = server_id_list[i]
			local details = details_list[i]

			add_order_to_world(server_id, details)
		end

		clientevents.PlayerEvents.i_have_bulk_created_orders_initially.fire()
	end

	for _, server_id, details in clientevents.RouberOrders.create_order.iter() do
		add_order_to_world(server_id, details)
	end
end

local vacant_orders_query = world:query(c.DeliveryOrderDetails, c.EntityId):with(c.Vacant):cached()
local function display_orders_to_ui()
	local orders_map = {} :: { [string]: types.DeliveryOrderType }

	for client_id, details, server_id in vacant_orders_query:iter() do
		local key = tostring(server_id)
		local restaurant_id = details.restaurant_id
		local house_id = details.destination_id
		local food_list = details.foods_list_id
		local conditions = details.conditions_list_id

		orders_map[key] = {}
	end
end

local function system()
	create_order_to_world()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
