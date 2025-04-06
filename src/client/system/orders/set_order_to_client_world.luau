local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local clientgamedata = require(ReplicatedStorage.client.store.clientgamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local server_id_map = require(ReplicatedStorage.client.store.server_id_map)
local uistore = require(ReplicatedStorage.client.app.uistore)

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

	assert(id ~= nil, `Restaurant server ID {server_id} must not be nil`)
	assert(world:contains(id), `Restaurant Id must exist in the world`)

	return id
end

local function find_valid_client_destination_id(server_id: t.Entity)
	local id = server_id_map.residence_map[server_id]

	assert(id ~= nil, `Residence server ID {server_id} must not be nil`)
	assert(world:contains(id), `Residence Id must exist in the world`)

	return id
end

local function add_order_to_world(
	_server_id: number,
	_details: remotes.RouberOrders_DeliveryType,
	_rewards: remotes.RouberOrders_DeliveryRewardType
)
	local server_id = blink_conv.as_entity(_server_id)
	local restaurant_id = blink_conv.as_entity(_details.restaurant_id)
	local destination_id = blink_conv.as_entity(_details.destination_id)

	local client_restaurant_id = find_valid_client_restaurant_id(restaurant_id)
	local client_destination_id = find_valid_client_destination_id(destination_id)
	local server_food_list = _details.foods_list_id
	local server_cond_list = _details.conditions_list_id

	local coins = _rewards.coins
	local gems = _rewards.gems
	local has_mystery_box = _rewards.has_mystery_box

	local order_id = world:entity() :: t.Entity

	--//TODO : we need to convert the food into [Server]: Client map too
	local delivery_details: types.DeliveryOrderDetailsComponentType = {
		restaurant_id = client_restaurant_id,
		destination_id = client_destination_id,
		foods_list_id = server_food_list :: never,
		conditions_list_id = server_cond_list :: never,
		order_tier = _details.order_tier,
	}
	world:set(order_id, c.EntityId, server_id)
	world:set(order_id, c.DeliveryOrderDetails, delivery_details)
	world:set(order_id, c.Gems, gems)
	world:set(order_id, c.Coins, coins)
	world:add(order_id, c.Vacant)

	if has_mystery_box then
		world:add(order_id, c.HasMysteryBox)
	end

	server_id_map.order_map[server_id] = order_id
end

local function create_order_to_world()
	-- Bulk creating is no longer necessary
	-- for _, server_id_list, details_list, reward_list in
	-- 	clientevents.RouberOrders.bulk_create_order.iter()
	-- do
	-- 	local n = #server_id_list
	-- 	for i = 1, n do
	-- 		local server_id = server_id_list[i]
	-- 		local details = details_list[i]
	-- 		local reward = reward_list[i]

	-- 		add_order_to_world(server_id, details, reward)
	-- 	end

	-- 	clientevents.PlayerEvents.i_have_bulk_created_orders_initially.fire()
	-- end

	for _, server_id, details, reward in clientevents.RouberOrders.create_order.iter() do
		add_order_to_world(server_id, details, reward)
	end
end

local vacant_orders_query =
	world:query(c.DeliveryOrderDetails, c.EntityId, c.Coins, c.Gems):with(c.Vacant):cached()
local function display_orders_to_ui()
	local orders_map = {} :: { [string]: types.DeliveryOrderType }

	-- for client_id, details, server_id, coins, gems in vacant_orders_query:iter() do
	for client_id, details, server_id, coins, gems in
		world:query(c.DeliveryOrderDetails, c.EntityId, c.Coins, c.Gems):with(c.Vacant):iter()
	do
		local key = tostring(server_id)
		-- print(`building the key = {key} with client_id = {client_id}`)
		local restaurant_id = details.restaurant_id :: t.Entity
		local food_list = details.foods_list_id
		local house_id = details.destination_id :: t.Entity
		local conditions = details.conditions_list_id

		local foods_list_display_type = {} :: { t.DeliveryOrderFoodType }

		for i, food_id in food_list do
			local client_food_id = server_id_map.food_map[food_id]
			assert(client_food_id, `Client food id does not exist for the server id of food {food_id}`)

			local client_food_details = clientgamedata.food_map[client_food_id]
			assert(
				client_food_details,
				`Client Food details does not exist for client id {client_food_id}`
			)

			local to_add: t.DeliveryOrderFoodType = {
				image = client_food_details.display_image,
				name = client_food_details.display_name,
				rarity = client_food_details.rarity_value,
			}

			table.insert(foods_list_display_type, to_add)
		end

		local client_restuarant_id = server_id_map.restaurant_map[restaurant_id]
		assert(
			client_restuarant_id,
			`Client restuarant id does not exist for server iD {restaurant_id}`
		)
		local client_restuarant_details = clientgamedata.restaurant_map[client_restuarant_id]
		assert(
			client_restuarant_details,
			`Client restuarant details does not exist for id {client_restuarant_details}`
		)

		local house_name = world:exists_get(house_id, c.Name)

		orders_map[key] = {
			delivery_type = "TODO, does not exist yet",
			-- we have not worked on this yet
			has_mystery_box = false,
			house_address = house_name,
			house_name = house_name,
			order_id = client_id :: t.Entity,
			-- We have not worked on this yet
			order_rating = details.order_tier,
			restaurant_address = `debug-orderid={client_id}, vacant={world:has(client_id, c.Vacant)}`,
			restaurant_image = client_restuarant_details.display_image,
			restaurant_name = client_restuarant_details.display_name,
			reward_amount = coins,
			foods_list = foods_list_display_type,
		}
	end

	uistore.DeliveryOrderList(orders_map)
end

local function mark_order_as_claimed()
	for _, status, _order_id, str in clientevents.RouberOrders.accept_order_response.iter() do
		-- go through all the orders and mark it as completed?
		if status then
			local order_id = blink_conv.as_entity(_order_id :: number)
			local client_order_id = server_id_map.order_map[order_id]

			if client_order_id == nil then
				warn(`Could not find the client. Normally this would be a bug.. Aborting req`)
				continue
			end

			world:remove(client_order_id, c.Vacant)
		end
	end
end

local function system()
	create_order_to_world()
	display_orders_to_ui()
	mark_order_as_claimed()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
