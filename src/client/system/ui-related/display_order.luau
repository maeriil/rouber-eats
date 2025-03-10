local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local t = require(ReplicatedStorage.types)
local ui_store = require(ReplicatedStorage.client.app.ui_store)

local c = require(ReplicatedStorage.common.ecs.components)
local create_delivery_order = require(ReplicatedStorage.common.ecs.prefabs.create_delivery_order)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for _, entity, restaurant, house, items in events.CreateAnOrderRequest:query():client():iter() do
		local current_order_list = ui_store.DeliveryOrderList()

		local e = create_delivery_order(restaurant, house, items)
		world:set(e, c.EntityId, entity)

		table.insert(current_order_list, e)
		print(current_order_list)
		ui_store.DeliveryOrderList(current_order_list)
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
