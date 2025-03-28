local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playerstore = require(ServerScriptService.server.store.playerstore)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
-- local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	-- for _, player in world:query(c.Client):iter() do
	-- 	local store = playerstore[player]
	-- 	if store == nil then continue end
	-- 	if store.has_sent_existing_world_order then continue end
	-- 	if
	-- 		not store.has_setup_apartments
	-- 		or not store.has_setup_restaurant
	-- 		or not store.has_setup_house
	-- 	then
	-- 		-- We need the client to have setup their restaurants and etc at least once
	-- 		continue
	-- 	end

	-- 	for order_id, details, house_id, restaurant_id in
	-- 		world
	-- 			:query(
	-- 				c.DeliveryOrderDetails,
	-- 				pair(c.EntityId, c.House),
	-- 				pair(c.EntityId, c.Restaurant)
	-- 			)
	-- 			:iter()
	-- 	do
	-- 		local house = world:get(house_id, c.Model) :: Model
	-- 		local restaurant = world:get(restaurant_id, c.Model) :: Model
	-- 		events.CreateAnOrderRequest
	-- 			:send(order_id, restaurant, house, details.items)
	-- 			:to(player)
	-- 	end

	-- 	store.has_sent_existing_world_order = true
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
