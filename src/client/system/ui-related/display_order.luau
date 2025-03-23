local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local create_delivery_order = require(ReplicatedStorage.common.ecs.prefabs.create_delivery_order)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for _, entity, restaurant, house, items in events.CreateAnOrderRequest:query():client():iter() do
		local current_order_list = uistore.DeliveryOrderList()

		local e = create_delivery_order(restaurant, house, items)
		world:set(e, c.EntityId, entity)

		table.insert(
			current_order_list,
			{
				clientid = e,
				deliverytype = "TODO",
				distance = -100,
				restaurant = {
					img = "TODO",
					location = "TODO",
					name = restaurant.Name,
				},
				reward = -100,
			} :: types.DeliveryOrderType
		)

		uistore.DeliveryOrderList(current_order_list)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.First,
	runConditions = {},
}
