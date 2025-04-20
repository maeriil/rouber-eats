-- stylua: ignore start
local ReplicatedStorage      = game:GetService("ReplicatedStorage")

local CREATE_UI_EVENT        = require(ReplicatedStorage.client.client_utils.CREATE_UI_EVENT)
local server_id_map          = require(ReplicatedStorage.client.store.server_id_map)
local jecs                   = require(ReplicatedStorage.pkg.jecs)
local phases                 = require(ReplicatedStorage.common.ecs.phases)
local try_accept_order_event = require(ReplicatedStorage.common.events.order.try_accept_order_event)
local throw_error            = require(ReplicatedStorage.common.utility.throw_error)

local c                      = require(ReplicatedStorage.common.ecs.components)
local world                  = require(ReplicatedStorage.common.ecs.world)
local __                     = jecs.Wildcard
-- stylua: ignore end

local accept_results = try_accept_order_event.from_server()
local function response()
	local should_update_ui = false
	for _, status, order_id in accept_results.iter() do
		if not status.success then
			warn(`Error handling has not been created yet`)
			throw_error(`Client failed; {status.error_msg}.`, 1)
			continue
		end

		local client_order_id = server_id_map.order_map[order_id]
		if client_order_id then
			should_update_ui = true
			-- We should force update order UI
			world:remove(client_order_id, c.Vacant)
		end
	end

	--[[
    We should update UI because we need to remove the current order from the list view
    so they don't press it again. In future this could change? Becuase we might want to
    force limit how many orders we see, so we may not want to immediately create like next
    order
  ]]
	if should_update_ui then
		CREATE_UI_EVENT(c.UI_update_orders_list)
	end
end

local function system()
	response()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
