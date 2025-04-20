-- stylua: ignore start
local ReplicatedStorage            = game:GetService("ReplicatedStorage")
local phases                       = require(ReplicatedStorage.common.ecs.phases)
local restaurant_general_dialogues = require(ReplicatedStorage.common.configs.dialogues.restaurant.restaurant_general_dialogues)
local pickup_order_event           = require(ReplicatedStorage.common.events.order.try_pickup_order_event)
-- stylua: ignore end

local from_server_verification = pickup_order_event.from_server()
local function system()
	for _, status in from_server_verification.iter() do
		restaurant_general_dialogues.verify_order_signal:fire(status.success, status.error_msg)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
