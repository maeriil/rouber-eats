-- stylua: ignore start
local ReplicatedStorage         = game:GetService("ReplicatedStorage")
local event_handle              = require(ReplicatedStorage.common.utility.remote_util)
local t                         = require(ReplicatedStorage.types)

local remotes                   = ReplicatedStorage.common.events.remotes
local try_altering_order_remote = remotes.order_events.try_altering_order_event
-- stylua: ignore end

local function to_client(player: Player, status: t.error_handling_status_t, order_id: t.Entity)
	try_altering_order_remote:FireClient(player, status, order_id)
end

local function from_server()
	return event_handle.create_client(
			try_altering_order_remote
		) :: event_handle.create_client<t.error_handling_status_t, t.Entity>
end

local function to_server()
	try_altering_order_remote:FireServer()
end

local function from_client()
	return event_handle.create_server(try_altering_order_remote) :: event_handle.create_server<>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
