local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local playerstore = require(ServerScriptService.server.store.playerstore)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local ref = require(ReplicatedStorage.common.ecs.ref)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local world = require(ReplicatedStorage.common.ecs.world)
local yetanothernet = require(ReplicatedStorage.pkg.yetanothernet)
local __ = jecs.Wildcard

local function wrapper<T...>(route: yetanothernet.Route<T...>)
	return function(client: Player | { Player }, ...: T...)
		route:send():to(client)
	end
end

local x = wrapper(events.IncreaseCoinCount)

local function system()
	for i, client, add_amount, curr_amount in
		world:query(c.Client, pair(c.Coins, c.Increase), c.Coins):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount + add_amount

		world:set(player_id, c.Coins, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.IncreaseCoinCount:send(add_amount):to(client)
		world:remove(i, pair(c.Coins, c.Increase))
	end

	for i, client, add_amount, curr_amount in
		world:query(c.Client, pair(c.Gems, c.Increase), c.Gems):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount + add_amount

		world:set(player_id, c.Gems, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.IncreaseGemCount:send(add_amount):to(client)
		world:remove(i, pair(c.Gems, c.Increase))
	end

	for i, client, remove_amount, curr_amount in
		world:query(c.Client, pair(c.Coins, c.Decrease), c.Coins):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount - remove_amount

		world:set(player_id, c.Coins, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.DecreaseGemCount:send(remove_amount):to(client)
		world:remove(i, pair(c.Coins, c.Decrease))
	end

	for i, client, remove_amount, curr_amount in
		world:query(c.Client, pair(c.Gems, c.Decrease), c.Gems):iter()
	do
		local player_id = ref(client)
		local new_amount = curr_amount - remove_amount

		world:set(player_id, c.Gems, new_amount)

		-- Fire remote event to client letting it know our coins increased by X amount
		events.DecreaseGemCount:send(remove_amount):to(client)
		world:remove(i, pair(c.Gems, c.Decrease))
	end
end

return {
	name = script.Name,
	system = system,
	phase = planckrunservice.Phases.Update,
	runConditions = {},
}
