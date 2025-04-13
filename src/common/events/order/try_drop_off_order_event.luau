-- stylua: ignore start
local ReplicatedStorage         = game:GetService("ReplicatedStorage")
local event_handle              = require(ReplicatedStorage.common.utility.remote_util)
local t                         = require(ReplicatedStorage.types)

local remotes                   = ReplicatedStorage.common.events.remotes
local try_drop_off_order_remote = remotes.order_events.try_drop_off_order_event
-- stylua: ignore end

local function to_client(player: Player, status: t.error_handling_status_t, house_id: t.Entity)
	try_drop_off_order_remote:FireClient(player, status, house_id)
end

local function from_server()
	return event_handle.create_client(
			try_drop_off_order_remote
		) :: event_handle.create_client<t.error_handling_status_t, t.Entity>
end

local function to_server(house_id: t.Entity)
	try_drop_off_order_remote:FireServer(house_id)
end

local function from_client()
	return event_handle.create_server(
			try_drop_off_order_remote
		) :: event_handle.create_server<t.Entity?>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
