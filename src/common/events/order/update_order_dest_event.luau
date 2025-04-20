-- stylua: ignore start
local ReplicatedStorage        = game:GetService("ReplicatedStorage")
local event_handle             = require(ReplicatedStorage.common.utility.remote_util)
local t                        = require(ReplicatedStorage.types)

local remotes                  = ReplicatedStorage.common.events.remotes
local update_order_dest_remote = remotes.order_events.update_order_destination_event
-- stylua: ignore end

local function to_client(player: Player, order_id: t.Entity, destination_id: t.Entity)
	update_order_dest_remote:FireClient(player, order_id, destination_id)
end

local function from_server()
	return event_handle.create_client(
			update_order_dest_remote
		) :: event_handle.create_client<t.Entity, t.Entity>
end

return {
	to_client = to_client,
	from_server = from_server,
}
