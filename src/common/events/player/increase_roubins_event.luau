-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle      = require(ReplicatedStorage.common.utility.remote_util)

local remotes           = ReplicatedStorage.common.events.remotes
local remote            = remotes.player_events.increase_roubins
-- stylua: ignore end

local function to_client(player: Player, increased_by: number)
	remote:FireClient(player, increased_by)
end

local function from_server()
	return event_handle.create_client(remote) :: event_handle.create_client<number>
end

return {
	to_client = to_client,
	from_server = from_server,
}
