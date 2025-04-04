local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local playerdatastore = require(ServerScriptService.server.store.playerdatastore)
local playersetupconfiguration = require(ServerScriptService.server.store.playersetupconfig)
local playerstore = require(ServerScriptService.server.store.playerstore)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function load_data(player: Player)
	playerdatastore[player] = {
		coins = 0,
		gems = 0,
		housetype = "House_BasicHouse",
		orderpity = 0,
		rating = 0.0,
		total_orders_delivered = 0,
		total_orders_stolen = 0,
		total_orders_altered = 0,
	}

	return
end

local function setup_config(player: Player)
	playersetupconfiguration[player] = {
		restaurant_setup = {
			server_sent = false,
			client_completed = false,
		},
		house_setup = {
			server_sent = false,
			client_completed = false,
		},
		loaded_in = {
			server_sent = false,
			client_completed = false,
		},
		map_setup = {
			server_sent = false,
			client_completed = false,
		},
		order_setup = {
			server_sent = false,
			client_completed = false,
		},
		food_setup = {
			server_sent = false,
			client_completed = false,
		},
	}

	playerstore[player] = {
		my_orders = {},
		my_accepted_orders = {},
		my_pickedup_orders = {},
		my_backpack_collectables = {},
		my_backpack_furnishings = {},
	}
end

local function system()
	for _, player, char in world:query(c.Client, c.Model):iter() do
		local datastore = playerdatastore[player]
		if datastore == nil then
			task.spawn(load_data, player)
		end

		local config = playersetupconfiguration[player]
		if config == nil then
			task.spawn(setup_config, player)
		end
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.PlayerAddedRemoved.Datastore,
	runConditions = {},
}
