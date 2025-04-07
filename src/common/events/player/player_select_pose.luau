local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle = require(ReplicatedStorage.common.utility.remote_util)
local types = require(ReplicatedStorage.types)

local remotes = ReplicatedStorage.common.events.remotes
local remote = remotes.player_pose

--[[
  When we reach the house, first the animation begins. The cutscene will just show the players
  walking up to the door, and then ringing the doorbell.

  Then the House Owner slam opens the door and theres a question mark bubble on their head
  with a little bit of head tilt animation. Then the cutscene ends and our Select Pose
  page shows up.

  This page will contain all of our available poses. Poses are just the way we present the
  order to the house. A house could have multiple orders, so we would need to map an order
  to the pose somehow? How would we do so?

  When we click on one of poses, it should fire event to server with the pose enum id, and
  MAYBE the order? or how does it work, idk

  If the pose fails, just give 0 rating
  If the pose succeeds and all verification passes, the House owner would then give some kind
  of rating based on some kind of lookup table. This means we need to start creating a
  NPC config files, and some ways for players to set their "preferences" too.
]]

local function to_server(pose_kind: string, order_id: types.Entity)
	remote:FireServer(pose_kind)
end

local function from_client()
	return event_handle.create_server(remote) :: event_handle.create_server<string, types.Entity>
end

return {
	to_server = to_server,
	from_client = from_client,
}
