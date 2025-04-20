-- stylua: ignore start
local ReplicatedStorage      = game:GetService("ReplicatedStorage")
local jecs                   = require(ReplicatedStorage.pkg.jecs)
local phases                 = require(ReplicatedStorage.common.ecs.phases)
local uistore                = require(ReplicatedStorage.client.app.uistore)
local decrease_roubins_event = require(ReplicatedStorage.common.events.player.decrease_roubins_event)
local increase_roubins_event = require(ReplicatedStorage.common.events.player.increase_roubins_event)

local c                      = require(ReplicatedStorage.common.ecs.components)
local world                  = require(ReplicatedStorage.common.ecs.world)
local __                     = jecs.Wildcard
-- stylua: ignore end

--//TODO: we need to do an extra animation when we are adding roubins
local increase_coins_list = increase_roubins_event.from_server()
local function increase_coins()
	for _, amount in increase_coins_list.iter() do
		local curr_count = world:exists_get(c.Client, c.Roubins)
		local final = curr_count + amount

		world:set(c.Client, c.Roubins, final)
		uistore.CashCurrency(final)
	end
end

local decrease_coins_list = decrease_roubins_event.from_server()
local function decrease_coins()
	for _, amount in decrease_coins_list.iter() do
		local curr_count = world:exists_get(c.Client, c.Roubins)
		local final = curr_count - amount

		world:set(c.Client, c.Roubins, final)
		uistore.CashCurrency(final)
	end
end

local function system()
	increase_coins()
	decrease_coins()
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
