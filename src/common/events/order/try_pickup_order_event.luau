-- stylua: ignore start
local ReplicatedStorage       = game:GetService("ReplicatedStorage")
local event_handle            = require(ReplicatedStorage.common.utility.remote_util)
local t                       = require(ReplicatedStorage.types)

local remotes                 = ReplicatedStorage.common.events.remotes
local try_pickup_order_remote = remotes.order_events.try_pickup_order_event
-- stylua: ignore end

local function to_client(player: Player, status: t.error_handling_status_t)
	try_pickup_order_remote:FireClient(player, status)
end

local function from_server()
	return event_handle.create_client(
			try_pickup_order_remote
		) :: event_handle.create_client<t.error_handling_status_t>
end

local function to_server(restaurant_name: string)
	try_pickup_order_remote:FireServer(restaurant_name)
end

local function from_client()
	return event_handle.create_server(try_pickup_order_remote) :: event_handle.create_server<string?>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
