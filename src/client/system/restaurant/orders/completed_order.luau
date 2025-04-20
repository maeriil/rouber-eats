-- stylua: ignore start
local ReplicatedStorage           = game:GetService("ReplicatedStorage")
local jecs                        = require(ReplicatedStorage.pkg.jecs)
local phases                      = require(ReplicatedStorage.common.ecs.phases)

local c                           = require(ReplicatedStorage.common.ecs.components)
local world                       = require(ReplicatedStorage.common.ecs.world)
local invoke_complete_order_event = require(ReplicatedStorage.common.events.order.invoke_complete_order_event)
local __                          = jecs.Wildcard
-- stylua: ignore end

local from_server = invoke_complete_order_event.from_server()
local function system()
	for _, reward_rating, reward_roubins, reward_conditions in from_server.iter() do
		-- We need to create a new cutscene for this now

		local cutscene_id = world:entity()
		world:add(cutscene_id, c.DeliveryRewardCutscene)
		world:add(cutscene_id, c.Start)
		world:set(cutscene_id, c.Cutscene, {
			triggered_id = -1 :: any, -- We don't care about what triggered it
		})
		world:set(cutscene_id, c.Roubins, reward_roubins)
		world:set(cutscene_id, c.Rating, reward_rating)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
