-- stylua: ignore start
local ReplicatedStorage                 = game:GetService("ReplicatedStorage")
local event_handle                      = require(ReplicatedStorage.common.utility.remote_util)
local types                             = require(ReplicatedStorage.types)

local remotes                           = ReplicatedStorage.common.events.remotes
local delivery_condition_outcome_remote = remotes.order_events.delivery_condition_outcome
-- stylua: ignore end

local function to_client(
	player: Player,
	order_id: types.Entity,
	condition_name: types.rouber_delivery_conditions_t,
	status: boolean
)
	delivery_condition_outcome_remote:FireClient(player, order_id, condition_name, status)
end

local function from_server()
	return event_handle.create_client(
			delivery_condition_outcome_remote
		) :: event_handle.create_client<types.Entity, types.rouber_delivery_conditions_t, boolean>
end

return {
	to_client = to_client,
	from_server = from_server,
}
