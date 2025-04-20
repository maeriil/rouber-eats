-- stylua: ignore start
local ReplicatedStorage               = game:GetService("ReplicatedStorage")
local event_handle                    = require(ReplicatedStorage.common.utility.remote_util)
local types                           = require(ReplicatedStorage.types)

local remotes                         = ReplicatedStorage.common.events.remotes
local start_delivery_condition_remote = remotes.order_events.start_delivery_condition
-- stylua: ignore end

local function to_client(
	player: Player,
	order_id: types.Entity,
	condition_name: types.rouber_delivery_conditions_t
)
	start_delivery_condition_remote:FireClient(player, order_id, condition_name)
end

local function from_server()
	return event_handle.create_client(
			start_delivery_condition_remote
		) :: event_handle.create_client<types.Entity, types.rouber_delivery_conditions_t>
end

return {
	to_client = to_client,
	from_server = from_server,
}
