-- stylua: ignore start
local ReplicatedStorage              = game:GetService("ReplicatedStorage")
local event_handle                   = require(ReplicatedStorage.common.utility.remote_util)
local t                              = require(ReplicatedStorage.types)

local remotes                        = ReplicatedStorage.common.events.remotes
local invoke_delivering_order_remote = remotes.order_events.invoke_delivering_order_event
-- stylua: ignore end

local function to_client(player: Player, server_destination_id: t.Entity, order_id: t.Entity)
	invoke_delivering_order_remote:FireClient(player, server_destination_id, order_id)
end

local function from_server()
	return event_handle.create_client(
			invoke_delivering_order_remote
		) :: event_handle.create_client<t.Entity, t.Entity>
end

local function to_server()
	invoke_delivering_order_remote:FireServer()
end

local function from_client()
	return event_handle.create_server(invoke_delivering_order_remote) :: event_handle.create_server<>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
