-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local server_id_map            = require(ReplicatedStorage.client.store.server_id_map)
local jecs                     = require(ReplicatedStorage.pkg.jecs)
local phases                   = require(ReplicatedStorage.common.ecs.phases)
local try_drop_off_order_event = require(ReplicatedStorage.common.events.order.try_drop_off_order_event)
local throw_error              = require(ReplicatedStorage.common.utility.throw_error)

local c                        = require(ReplicatedStorage.common.ecs.components)
local world                    = require(ReplicatedStorage.common.ecs.world)
local __                       = jecs.Wildcard
-- stylua: ignore end

local drop_off_event = try_drop_off_order_event.from_server()
local function system()
	--
	for _, status, house_id in drop_off_event.iter() do
		if status.success then
			local client_house_id = server_id_map.residence_map[house_id]
			if client_house_id == nil then
				throw_error(
					`Could not locate a valid client house id. This is a bug that occursed in drop off event`
				)
			end

			local cutscene_id = world:entity()
			world:set(cutscene_id, c.Cutscene, {
				triggered_id = client_house_id,
			})
			world:add(cutscene_id, c.Start)
			world:add(cutscene_id, c.DeliveryCutscene)
			world:add(cutscene_id, c.IsCutscenePlaying)
			world:add(c.Client, c.IsCutscenePlaying)
		else
			throw_error(`Drop off failed with issue {status.error_msg}`)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
