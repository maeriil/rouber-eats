-- stylua: ignore start
local ReplicatedStorage            = game:GetService("ReplicatedStorage")
local event_handle                 = require(ReplicatedStorage.common.utility.remote_util)
local t                            = require(ReplicatedStorage.types)

local remotes                      = ReplicatedStorage.common.events.remotes
local invoke_complete_order_remote = remotes.order_events.invoke_complete_order_event
-- stylua: ignore end

local function to_client(
	player: Player,
	net_rating: number,
	net_roubins: number,
	conditions_completed: t.Array<t.rouber_delivery_conditions_t>
)
	invoke_complete_order_remote:FireClient(player, net_rating, net_roubins, conditions_completed)
end

local function from_server()
	return event_handle.create_client(
			invoke_complete_order_remote
		) :: event_handle.create_client<number, number, t.Array<t.rouber_delivery_conditions_t>>
end

local function to_server(house_id: t.Entity)
	invoke_complete_order_remote:FireServer(house_id)
end

local function from_client()
	return event_handle.create_server(
			invoke_complete_order_remote
		) :: event_handle.create_server<t.Entity?>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
