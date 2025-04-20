-- stylua: ignore start
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local delivery_conditions = require(ReplicatedStorage.common.configs.delivery_conditions)
local c                   = require(ReplicatedStorage.common.ecs.components)
local world               = require(ReplicatedStorage.common.ecs.world)
local playerstore         = require(ServerScriptService.server.store.playerstore)
local t                   = require(ReplicatedStorage.types)
-- stylua: ignore end

--[[
  Similar to update_deliver_conditions, given a phase and an order_id, we want to
  start some conditions as well. Its created as a function for similar reasons since we would
  need to call them at AccepOrderPhase, Pickup, Dropoff phases

  The side effect in this function is that it updates the active_conditions table and adds a
  new ticket_id entry if required
]]

local function start_delivery_conditions(currphase: t.Entity, player: Player, order_id: t.Entity)
	local store = playerstore[player]
	local delivery_details = world:exists_get(order_id, c.DeliveryOrderDetails)
	local order_conditions = delivery_details.conditions_list_id

	for _, condition_key: t.rouber_delivery_conditions_t in order_conditions do
		local details = delivery_conditions[condition_key]

		-- We havent reached the point in phase to start it or we are already past it
		if details.start_phase ~= currphase then
			continue
		end

		warn(`Starting the condition {condition_key} 4 phase`)
		local ticket_id = details.create_order_condition(order_id)
		local active_conditions = store.my_active_delivery_conditions
		table.insert(active_conditions, ticket_id)
	end
end

return start_delivery_conditions
