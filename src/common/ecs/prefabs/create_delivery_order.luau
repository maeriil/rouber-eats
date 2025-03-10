local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

local function create_delivery_order(restaurant: Model, house: Model, items: { string })
	local restaurant_id = ref(restaurant)
	local house_id = ref(house)
	local house_name, house_position = world:get(house_id, c.Name, c.Position)
	local restaurant_name, restaurant_position = world:get(restaurant_id, c.Name, c.Position)

	assert(restaurant_name, `Restaurant name must exist for all houses in game`)
	assert(house_name, `House name must exist for all houses in game`)
	assert(restaurant_position, `Restaurant position must exist for all houses in game`)
	assert(house_position, `House position must exist for all houses in game`)

	local e = world:entity()
	world:set(e, c.DeliveryOrderDetails, {
		audience_name = house_name,
		restaurant_name = restaurant_name,
		items = items,
	})
	world:set(e, pair(c.Position, c.House), house_position)
	world:set(e, pair(c.Position, c.Restaurant), restaurant_position)
	world:set(e, pair(c.EntityId, c.House), house_id)
	world:set(e, pair(c.EntityId, c.Restaurant), restaurant_id)

	return e
end

return create_delivery_order
