-- stylua: ignore start
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local event_handle        = require(ReplicatedStorage.common.utility.remote_util)
local types               = require(ReplicatedStorage.types)

local remotes             = ReplicatedStorage.common.events.remotes
local create_order_remote = remotes.order_events.create_order_event
-- stylua: ignore end

local function to_client(
	player: Player,
	order_id: types.Entity,
	delivery_details: types.rouber_delivery_details_t,
	reward_details: types.rouber_deliver_reward_details_t
)
	create_order_remote:FireClient(player, order_id, delivery_details, reward_details)
end

local function from_server()
	return event_handle.create_client(create_order_remote) :: event_handle.create_client<
		types.Entity,
		types.rouber_delivery_details_t,
		types.rouber_deliver_reward_details_t
	>
end

return {
	to_client = to_client,
	from_server = from_server,
}
