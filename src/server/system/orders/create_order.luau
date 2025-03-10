local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local create_delivery_order = require(ReplicatedStorage.common.ecs.prefabs.create_delivery_order)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local pick_random_entity = require(ReplicatedStorage.common.utility.pick_random_entity)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local MAX_ORDERS_IN_WORLD = 1
local function system()
	local n = 0
	for i in world:each(c.DeliveryOrderDetails) do
		n += 1
	end

	if n >= MAX_ORDERS_IN_WORLD then
		return
	end

	-- Ensure at least one/two houses exist in the world

	local house_id = pick_random_entity({ c.House })
	local restaurant_id = pick_random_entity({ c.Restaurant })
	if house_id == nil or restaurant_id == nil then
		return
	end

	local res_model = world:get(restaurant_id, c.Model)
	local house_model = world:get(house_id, c.Model)

	assert(
		res_model ~= nil,
		"Restaurant model must exist in server. File an issue as this shouldn't be an issue"
	)
	assert(
		house_model ~= nil,
		"Restaurant model must exist in server. File an issue as this shouldn't be an issue"
	)
	local food_list = {
		"Hamburger",
		"Juice",
	}

	local e = create_delivery_order(res_model, house_model, food_list)
	print("Created delivery order, firing to all clients..")
	events.CreateAnOrderRequest:send(e, res_model, house_model, food_list)
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
