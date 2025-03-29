local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local gamedata = require(ServerScriptService.server.store.gamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local playersetupconfig = require(ServerScriptService.server.store.playersetupconfig)
local serverevents = require(ServerScriptService.server.serverevents)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local blink_conv = require(ReplicatedStorage.common.utility.blink_conv)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local all_foods = world:query(c.Name):with(c.Food):cached()
local function system()
	for _, client in world:query(c.Client):iter() do
		local config = playersetupconfig[client]
		if not config then
			continue
		end
		if config.food_setup.server_sent then
			continue
		end

		local entity_id_list = {}
		local food_name_list = {}

		for server_id, _display_name in all_foods:iter() do
			table.insert(entity_id_list, blink_conv.from_entity(server_id))
			-- We dont want the display name but rather the root name, we shoudl lookup here
			local data = gamedata.food_map[server_id :: t.Entity]
			table.insert(food_name_list, data.string_id)
		end

		serverevents.RouberOrders.bulk_setup_food.fire(client, entity_id_list, food_name_list)
		config.food_setup.server_sent = true
		warn(`Sent to client to setup their foods`)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.WorldSetups,
	runConditions = {},
}
