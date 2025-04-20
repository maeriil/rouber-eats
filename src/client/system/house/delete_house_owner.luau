-- stylua: ignore start
local ReplicatedStorage        = game:GetService("ReplicatedStorage")

local server_id_map            = require(ReplicatedStorage.client.store.server_id_map)
local jecs                     = require(ReplicatedStorage.pkg.jecs)
local phases                   = require(ReplicatedStorage.common.ecs.phases)
local delete_house_owner_event = require(ReplicatedStorage.common.events.house.delete_house_owner_event)

local p                        = require(ReplicatedStorage.common.ecs.pairs)
local c                        = require(ReplicatedStorage.common.ecs.components)
local world                    = require(ReplicatedStorage.common.ecs.world)
local __                       = jecs.Wildcard
-- stylua: ignore end

local from_server = delete_house_owner_event.from_server()
local function system()
	for i, server_owner_id, server_house_id in from_server.iter() do
		local client_owner_id = server_id_map.residence_owner_map[server_owner_id]
		local client_house_id = server_id_map.residence_map[server_house_id]
		warn(`Deleting the house owner id{server_owner_id}`)

		if client_owner_id ~= nil then
			world:delete(client_owner_id)
		end

		if client_house_id ~= nil then
			local interior_id = world:get(client_house_id, p.EntityId(c.Interior))
			local exterior_id = world:get(client_house_id, p.EntityId(c.Exterior))

			if interior_id then
				world:delete(interior_id)
			end
			if exterior_id then
				world:delete(exterior_id)
			end

			world:delete(client_house_id)
		end

		server_id_map.residence_owner_map[server_owner_id] = nil
		server_id_map.residence_map[server_house_id] = nil
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
