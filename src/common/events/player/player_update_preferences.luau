local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle = require(ReplicatedStorage.common.utility.remote_util)
local types = require(ReplicatedStorage.types)

local remotes = ReplicatedStorage.common.events.remotes
local remote = remotes.player_pose

--[[
  Clients are able to pick like their personality preferences. These personality pref are
  just a fancy way of saying I like these pose categories, and dislikee these ones
  In future, im not sure if i would want it but maybe we want the players to unlock some of them?
  Not sure tbh

  Once it is set and verified, server will return back result which will then be set on the client
  ui store If some poses aren't allowed (for ex, both like n dislike has a same pose), then it will
  need to show some error message in UI. If it succeeds, we need to display on UI too
  feedbacks r important after all...
]]

local function to_server(
	my_likes: types.Array<types.rouber_pose_category_t>,
	my_dislikes: types.Array<types.rouber_pose_category_t>
)
	remote:FireServer(my_likes, my_dislikes)
end

local function from_client()
	return event_handle.create_server(remote) :: event_handle.create_server<
		types.Array<types.rouber_pose_category_t>,
		types.Array<types.rouber_pose_category_t>
	>
end

local function to_client(
	player: Player,
	status: {
		success: boolean,
		error_msg: string,
	},
	likes: types.Array<types.rouber_pose_category_t>,
	dislikes: types.Array<types.rouber_pose_category_t>
)
	remote:FireClient(player, status, likes, dislikes)
end

local function from_server()
	return event_handle.create_client(remote) :: event_handle.create_client<{
		success: boolean,
		error_msg: string,
	}, types.Array<types.rouber_pose_category_t>, types.Array<types.rouber_pose_category_t>>
end

return {
	to_server = to_server,
	from_client = from_client,
	to_client = to_client,
	from_server = from_server,
}
