-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle      = require(ReplicatedStorage.common.utility.remote_util)
local types             = require(ReplicatedStorage.types)

local remotes           = ReplicatedStorage.common.events.remotes
local remote            = remotes.house_events.delete_house_owner
-- stylua: ignore end

local function to_client(player: Player, owner_id: types.Entity, house_id: types.Entity)
	remote:FireClient(player, owner_id, house_id)
end

local function to_all_clients(owner_id: types.Entity, house_id: types.Entity)
	remote:FireAllClients(owner_id, house_id)
end

local function from_server()
	return event_handle.create_client(
			remote
		) :: event_handle.create_client<types.Entity, types.Entity>
end

return {
	to_client = to_client,
	to_all_clients = to_all_clients,
	from_server = from_server,
}
