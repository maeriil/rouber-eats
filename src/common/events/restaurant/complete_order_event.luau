local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle = require(ReplicatedStorage.common.utility.remote_util)
local types = require(ReplicatedStorage.types)

local remotes = ReplicatedStorage.common.events.remotes
local remote = remotes.restaurant_complete_order

local function to_client(
	player: Player,
	status: {
		success: boolean,
		error_msg: string,
	}
)
	remote:FireClient(player, status)
end

local function from_server()
	return event_handle.create_client(
			remote
		) :: event_handle.create_client<{ success: boolean, error_msg: string }>
end

local function to_server(house_id: types.Entity)
	remote:FireServer(house_id)
end

local function from_client()
	return event_handle.create_server(remote) :: event_handle.create_server<types.Entity>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
