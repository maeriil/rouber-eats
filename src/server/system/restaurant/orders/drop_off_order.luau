-- stylua: ignore start
local ReplicatedStorage          = game:GetService("ReplicatedStorage")
local ServerScriptService        = game:GetService("ServerScriptService")

local start_delivery_conditions  = require(ServerScriptService.server.server_utils.start_delivery_conditions)
local update_delivery_conditions = require(ServerScriptService.server.server_utils.update_delivery_conditions)
local jecs                       = require(ReplicatedStorage.pkg.jecs)
local phases                     = require(ReplicatedStorage.common.ecs.phases)
local playerstore                = require(ServerScriptService.server.store.playerstore)
local try_drop_off_order_event   = require(ReplicatedStorage.common.events.order.try_drop_off_order_event)

local c                          = require(ReplicatedStorage.common.ecs.components)
local p                          = require(ReplicatedStorage.common.ecs.pairs)
local ref                        = require(ReplicatedStorage.common.ecs.ref)
local world                      = require(ReplicatedStorage.common.ecs.world)
local t                          = require(ReplicatedStorage.types)
local __                         = jecs.Wildcard
-- stylua: ignore end

local function try_drop_off_order_request(player: Player, house_id: t.Entity?)
	local my_orders = playerstore[player].my_pickedup_orders
	local to_drop_off = playerstore[player].my_orders_to_drop_off

	if not house_id or not world:contains(house_id) or not world:has(house_id, c.House) then
		try_drop_off_order_event.to_client(player, {
			success = false,
			error_msg = "Did not provide a valid house id",
		}, 0 :: never)
		return
	end

	local orders_to_the_house = {}
	local orders_index = {}
	for idx, order_id in my_orders do
		local details = world:exists_get(order_id, c.DeliveryOrderDetails)
		if details.destination_id ~= house_id then
			continue
		end

		table.insert(orders_to_the_house, order_id)
		table.insert(orders_index, idx)
	end

	if #orders_to_the_house == 0 then
		try_drop_off_order_event.to_client(player, {
			success = false,
			error_msg = "Could not find orders for the provided house_id",
		}, 0 :: never)
		return
	end

	for idx, _order_id in orders_to_the_house do
		local remove_index = orders_index[idx]
		local order_id = _order_id :: t.Entity --//TODO: Luau and jecs issue

		table.insert(to_drop_off, order_id)
		table.remove(orders_to_the_house, remove_index)

		update_delivery_conditions(c.DropOffOrderPhase, player, order_id)
		start_delivery_conditions(c.DropOffOrderPhase, player, order_id)
	end

	try_drop_off_order_event.to_client(player, {
		success = true,
		error_msg = "",
	}, house_id)
end

local from_client_event = try_drop_off_order_event.from_client()
local function system()
	for _, player, house_id in from_client_event.iter() do
		try_drop_off_order_request(player, house_id)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
