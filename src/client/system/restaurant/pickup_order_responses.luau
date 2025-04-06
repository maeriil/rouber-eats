local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local restaurant_general_dialogues =
	require(ReplicatedStorage.common.configs.dialogues.restaurant.restaurant_general_dialogues)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local pickup_order_event = require(ReplicatedStorage.common.events.restaurant.pickup_order_event)
local t = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local from_server_verification = pickup_order_event.from_server()
local function system()
	for _, status in from_server_verification.iter() do
		print(`GOT STATUS {status.success} with msg {status.error_msg}`)
		restaurant_general_dialogues.verify_order_signal:fire(status.success, status.error_msg)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
