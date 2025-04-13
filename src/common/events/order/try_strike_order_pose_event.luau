-- stylua: ignore start
local ReplicatedStorage            = game:GetService("ReplicatedStorage")
local event_handle                 = require(ReplicatedStorage.common.utility.remote_util)
local t                            = require(ReplicatedStorage.types)

local remotes                      = ReplicatedStorage.common.events.remotes
local try_strike_order_pose_remote = remotes.order_events.try_strike_order_pose_event
-- stylua: ignore end

local function to_client(
	player: Player,
	status: t.error_handling_status_t,
	pose_kind_for_player: t.rouber_pose_t,
	emotion_kind_for_customer: t.rouber_emotion_t
)
	try_strike_order_pose_remote:FireClient(
		player,
		status,
		pose_kind_for_player,
		emotion_kind_for_customer
	)
end

local function from_server(): (t.error_handling_status_t, t.rouber_pose_t, t.rouber_emotion_t)
	-- return event_handle.create_client(try_strike_order_pose_remote) :: event_handle.create_client<
	-- 	t.error_handling_status_t,
	-- 	t.rouber_pose_t,
	-- 	t.rouber_emotion_t
	-- >

	return try_strike_order_pose_remote.OnClientEvent:Wait()
end

local function to_server(order_id: t.Entity, pose_kind: t.rouber_pose_t)
	try_strike_order_pose_remote:FireServer(order_id, pose_kind)
end

local function from_client()
	return event_handle.create_server(
			try_strike_order_pose_remote
		) :: event_handle.create_server<t.Entity?, t.rouber_pose_t?>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
