-- stylua: ignore start
local ReplicatedStorage           = game:GetService("ReplicatedStorage")
local event_handle                = require(ReplicatedStorage.common.utility.remote_util)
local t                           = require(ReplicatedStorage.types)

local remotes                     = ReplicatedStorage.common.events.remotes
local delete_invalid_order_remote = remotes.order_events.delete_invalid_order_event
-- stylua: ignore end

local function to_client(player: Player, order_id: t.Entity)
	delete_invalid_order_remote:FireClient(player, order_id)
end

local function from_server()
	return event_handle.create_client(
			delete_invalid_order_remote
		) :: event_handle.create_client<t.Entity>
end

return {
	to_client = to_client,
	from_server = from_server,
}
