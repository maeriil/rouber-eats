local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local gamedata = require(ServerScriptService.server.store.gamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local p = require(ReplicatedStorage.common.ecs.pairs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)
local t = require(ReplicatedStorage.types)

local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local c = require(ReplicatedStorage.common.ecs.components)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

--[[
  should the order be for everyone, or specific to some player only? When we make it specific
  to some player only, we need to mark each of them as shown the player kinda thing
  Suppose we have 4 orders max per player. We should then do
    iterate over all players in the game
    Count how many orders are we showing it to them right now
    Spawn the 4 - curr_shown_amount orders
    Send it to their remote

  What if we want to display some orders that are for everyone?
]]

local _TEMPORARY_MAX_ORDER_IN_SERVER = 5
local vacant_orders_count = world:query(c.DeliveryOrderDetails):with(c.Vacant):cached()
local function should_create_order()
	--[[
		In future, this should become more complicated as we want to create orders depending on
		what the general level of the player in the server is + creating orders based on things
		like value and tiers

		For now, we don't have that concept yet, so we will just create orders until we are
		at X amount of threshold. We only consider vacant orders too
	]]

	local n = 0
	for _ in vacant_orders_count:iter() do
		n += 1
	end

	if n == _TEMPORARY_MAX_ORDER_IN_SERVER then
		print(`since n = {n}, we shouldn't create any orders....`)
		return false
	end
	return true
end

local all_house_owners = world:query(c.Name):with(c.HouseOwner):cached()
local function select_a_house_owner()
	local house_owner_list = {}
	for house_owner_id, name in all_house_owners:iter() do
		table.insert(house_owner_list, house_owner_id)
	end

	local random = Random.new(os.clock())
	local index = random:NextInteger(1, #house_owner_list)

	return house_owner_list[index] :: t.Entity
end

local all_restaurants =
	world:query(c.Name):with(c.Restaurant):without(c.Interior, c.Exterior):cached()
local function select_a_restaurant()
	local restaurant_list = {}
	for restaurant_id, name in all_restaurants:iter() do
		table.insert(restaurant_list, restaurant_id)
	end

	local random = Random.new(os.clock())
	local index = random:NextInteger(1, #restaurant_list)

	return restaurant_list[index] :: t.Entity
end

local function select_foods_from_restaurant(foods: { t.Entity })
	--[[
		We need to revamp the way we do this.....
		We are also assuming that we only selected 1 food entity

	]]
	local n = #foods
	local random = Random.new(os.clock())
	local index = random:NextInteger(1, n)

	print(`Selected the food {world:get(foods[index], c.Name)}`)

	return foods[index] :: t.Entity
end

local function should_create_mystery_box()
	return false
end

local function create_order()
	-- Depending on the tier of the order, both of these would be selected different
	-- For now, assume all of them are weighted equally
	local order_owner_id = select_a_house_owner()
	local residence_id = world:get(order_owner_id, c.Residence) :: t.Entity

	local restaurant_id = select_a_restaurant()
	local config_data = gamedata.restaurant_map[restaurant_id]
	local foods = config_data.foods
	local selected_food = select_foods_from_restaurant(foods)

	local order_id = world:entity()
	local delivery_details = {
		restaurant_id = restaurant_id,
		destination_id = residence_id,
		foods_list_id = { selected_food },
		conditions_list_id = {
			-- Conditions aren't created yet
		},
	}
	local coins_reward = math.random(250, 1000)
	local should_have_mystery_box = should_create_mystery_box()

	world:set(order_id, c.DeliveryOrderDetails, delivery_details)
	if should_have_mystery_box then
		world:add(order_id, c.HasMysteryBox)
	end
	--[[
		TODO: we need a better way to figure out how much coins should we recieve from order
		We willalso never receive gems from it directly so
	]]
	world:set(order_id, c.Coins, coins_reward)
	world:set(order_id, c.Gems, 0)
	world:add(order_id, c.Vacant)
	warn(`Created a delivery order...`)

	-- We want to fire the order details to player who have their client world setup
	-- otherwise, the bulk create will do its job. A player is considered setup if their
	-- client world, restaurant and houses are setup
	local clients_with_completed_setup = {}
	for client_id, client in world:query(c.Client):iter() do
		local config = playersetupconfig[client]

		-- order_setup is only completed once restaurant and etc are done so we are sure they are setup by now
		if config and config.order_setup.client_completed then
			table.insert(clients_with_completed_setup, client)
			warn(`The client {client.Name} has completed setup. So we will fire orders to them`)
		else
			warn(`The client {client.Name} has NOT completed setups..... Skipping.....`)
		end
	end

	serverevents.RouberOrders.create_order.fire_list(
		clients_with_completed_setup,
		blink_conv.from_entity(order_id),
		delivery_details :: never,
		{
			coins = coins_reward,
			gems = 0,
			has_mystery_box = should_have_mystery_box,
		}
	)

	-- Fire the event now

	-- Now the order should contain information such as food and etc
	--[[

    The restuarant should hold configurations for the following things

    The kinds of foods, drinks and etc. If the quantity is higher, the reward is usually higher
    If the type of food is higher quality, then it means its like higher tier

    For now, we will only select quantity = 1
    And the food will be only one type, we will need to create things like images of the food too?
  ]]
end

local function adjust_order_count_limit()
	local n = #Players:GetPlayers()

	_TEMPORARY_MAX_ORDER_IN_SERVER = math.max(5, math.min(_TEMPORARY_MAX_ORDER_IN_SERVER * n, 25))
end

local last_created = 0
local MIN_TIME_UNTIL_NEXT_ORDER = 2 -- seconds
local function system()
	if not should_create_order() then
		return
	end
	local now = os.clock()
	if now - last_created < MIN_TIME_UNTIL_NEXT_ORDER then
		return
	end

	last_created = now
	create_order()
	adjust_order_count_limit()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
