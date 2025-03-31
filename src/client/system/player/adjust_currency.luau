local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local t = require(ReplicatedStorage.types)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function increase_coins()
	for _, amount in clientevents.RouberCurrency.IncreaseCoins.iter() do
		warn(`Updated client's currency to {amount}`)
		uistore.CashCurrency(amount)
	end
end

local function system()
	increase_coins()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
