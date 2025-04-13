-- stylua: ignore start
local ReplicatedStorage          = game:GetService("ReplicatedStorage")
local jecs                       = require(ReplicatedStorage.pkg.jecs)
local phases                     = require(ReplicatedStorage.common.ecs.phases)

local t                          = require(ReplicatedStorage.types)
local ct                         = require(ReplicatedStorage.types.config_types)
local p                          = require(ReplicatedStorage.common.ecs.pairs)
local c                          = require(ReplicatedStorage.common.ecs.components)
local tr                         = require(ReplicatedStorage.common.ecs.target)
local world                      = require(ReplicatedStorage.common.ecs.world)
local delivery_condition_outcome = require(ReplicatedStorage.common.events.order.delivery_condition_outcome)
local __                         = jecs.Wildcard
-- stylua: ignore end

local conditions_out_of_time = world
	:query(c.Parent, c.EntityId)
	:with(c.DeliveryOrderCondition)
	:without(p.Lifetime(c.WorkingAt), c.Success, c.Failure)
	:cached()

--[[
	The reason for these function is that we want to display to the UI as soon as they fail it
	otherwise we wouldn't need it tbh..
]]

local function system()
	for cond_id, order_id, condition_id in conditions_out_of_time:iter() do
		warn(`The specified condition ran out of time!!!`)
		warn(`We are marking it as a failed...`)
		-- Basically we ran out of time and we need to mark the order as completed
		world:add(cond_id, c.Failure)

		local player_id = world:target(order_id, c.Client) :: t.Entity
		local player = world:exists_get(player_id, c.Client)

		-- Send details that the player has failed the event, then the client will display the relevant
		-- info

		delivery_condition_outcome.to_client(player, order_id :: t.Entity, cond_id :: t.Entity, false)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
