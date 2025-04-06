local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle = require(ReplicatedStorage.common.utility.remote_util)
local types = require(ReplicatedStorage.types)

local remotes = ReplicatedStorage.common.events.remotes
local remote = remotes.player_rating_change

--[[
  New rating is our clients new rating value, which is a value from [-1, 5)
  Realistically, we will never let it reach 5 tbh for now at least, we might increase the
  cap as well in future

  has_changed_level is for when a player goes from like 0.99 -> 1.001 or 1.001 -> 0.99,
  their int floord value is different. When this happens, client would want to do another layer
  of animation so
]]

local function to_client(player: Player, new_rating: number, has_changed_level: boolean)
	remote:FireClient(player, new_rating, has_changed_level)
end

local function from_server()
	return event_handle.create_client(remote) :: event_handle.create_client<number, boolean>
end

return {
	to_client = to_client,
	from_server = from_server,
}
