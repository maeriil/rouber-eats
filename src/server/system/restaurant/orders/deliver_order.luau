-- stylua: ignore start
local ReplicatedStorage         = game:GetService("ReplicatedStorage")
local ServerScriptService       = game:GetService("ServerScriptService")

local start_delivery_conditions = require(ServerScriptService.server.server_utils.start_delivery_conditions)
local jecs                      = require(ReplicatedStorage.pkg.jecs)
local phases                    = require(ReplicatedStorage.common.ecs.phases)
local playerstore               = require(ServerScriptService.server.store.playerstore)
local invoke_delivering_order   = require(ReplicatedStorage.common.events.order.invoke_delivering_order_event)
local throw_error               = require(ReplicatedStorage.common.utility.throw_error)

local c                         = require(ReplicatedStorage.common.ecs.components)
local t                         = require(ReplicatedStorage.types)
local world                     = require(ReplicatedStorage.common.ecs.world)
local __                        = jecs.Wildcard
-- stylua: ignore end

local function try_deliver_order(player: Player)
	local store = playerstore[player]

	for idx, my_order_id in store.my_pickedup_orders do
		if not world:has(my_order_id, c.WorkingAt) then
			continue
		end

		local details = world:exists_get(my_order_id, c.DeliveryOrderDetails)
		local house_id = details.destination_id :: t.Entity

		world:remove(my_order_id, c.WorkingAt)
		invoke_delivering_order.to_client(player, house_id, my_order_id :: t.Entity)

		local order_id = my_order_id :: t.Entity --//TODO: luau and jecs
		start_delivery_conditions(c.PickupOrderPhase, player, order_id)
		return
	end

	throw_error(`Could not find a valid order to deliver...`)
end

local from_client_event = invoke_delivering_order.from_client()
local function system()
	for _, player in from_client_event.iter() do
		try_deliver_order(player)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
