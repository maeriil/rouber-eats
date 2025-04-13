-- stylua: ignore start
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local delivery_conditions = require(ReplicatedStorage.common.configs.delivery_conditions)
local c                   = require(ReplicatedStorage.common.ecs.components)
local world               = require(ReplicatedStorage.common.ecs.world)
local playerstore         = require(ServerScriptService.server.store.playerstore)
local t                   = require(ReplicatedStorage.types)
-- stylua: ignore end

local function get_condition_key(condition_id: t.Entity): t.rouber_delivery_conditions_t
	local key = world:exists_get(condition_id, c.Name)

	-- Never cast because it somehow stays as string | string
	return key :: never
end

--[[
  Main idea is that this will depend on what phase the ticket is to be called at. For ex
  update_deliver_condition(c.PickupPhase, player, order_id)

  Then, it will go through all the active current orders, and compare their end phase to
  curr phase since we only want to process things related to its end phase

  The main side effect is that it updates the ticket entity to success or failure if we
  are to process it
]]
local function update_delivery_conditions(currphase: t.Entity, player: Player, order_id: t.Entity)
	local store = playerstore[player]
	local active_conditions = store.my_active_delivery_conditions

	for _, ticket_id in active_conditions do
		local parent_id, condition_id = world:exists_get(ticket_id, c.Parent, c.EntityId)
		if parent_id ~= order_id then
			continue
		end

		local condition_key: t.rouber_delivery_conditions_t = get_condition_key(condition_id :: never)
		local details = delivery_conditions[condition_key]

		if details.end_phase ~= currphase then
			-- This means we condition's terminal phase is not the current phase, so we don't manually
			-- process it yet
			continue
		end

		local is_success = details.is_condition_successful(ticket_id)
		warn(
			`Evaluating the condition {condition_key} 4 phase {world:exists_get(condition_id, c.Name)}`
		)

		if is_success then
			warn(`You passed the condition!`)
			world:add(ticket_id, c.Success)
		else
			warn(`You failed the condition :(`)
			world:add(ticket_id, c.Failure)
		end
	end
end

return update_delivery_conditions
