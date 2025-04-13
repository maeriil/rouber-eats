-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local poses = require(ReplicatedStorage.common.configs.poses)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
-- local select_pose = require(ReplicatedStorage.common.events.player.player_select_pose_event)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local tr = require(ReplicatedStorage.common.ecs.target)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local throw_error = require(ReplicatedStorage.common.utility.throw_error)
local __ = jecs.Wildcard
-- stylua: ignore end

local function end_with_failure(player: Player, error_msg: string)
	warn(error_msg)

	-- Setup error handling remote here
end

-- local function try_select_pose(player: Player, pose_kind: t.rouber_pose_t?, order_id: t.Entity?)
-- 	if
-- 		not order_id
-- 		or not world:contains(order_id)
-- 		or not world:has(order_id, c.DeliveryOrderDetails)
-- 	then
-- 		end_with_failure(player, `Provided an invalid order id`)
-- 		return
-- 	end

-- 	if not pose_kind or not poses[pose_kind] then
-- 		end_with_failure(player, `Provided an invalid pose kind`)
-- 		return
-- 	end

-- 	local order_details = world:exists_get(order_id, c.DeliveryOrderDetails)
-- 	local house_id = order_details.destination_id
-- 	local pose_details = poses[pose_kind]
-- 	local category = pose_details.category

-- 	if house_id == nil then
-- 		throw_error(`{script.Name}: house_id is nil, this is a bad issue to occur`)
-- 		return
-- 	end

-- 	--//TODO: we should change this tbh, and instead have house_id have single Owner component
-- 	-- and instead add Tag like NPC/Client etc if needed
-- 	local owner_id = world:exists_get(house_id, c.OccupiedByNPC)
-- 		or world:exists_get(house_id, c.OccupiedByPlayer)
-- 	local owner_preferences = world:exists_get(owner_id, c.PreferredPoseCategory)

-- 	local additional_ratings = 0

-- 	if table.find(owner_preferences.likes, category) then
-- 		additional_ratings = 1
-- 	elseif table.find(owner_preferences.dislikes, category) then
-- 		additional_ratings = -1
-- 	else
-- 		additional_ratings = 0
-- 	end

-- 	-- We should pass this to the system that deals with final calculation/delivery rating
-- end

-- local from_client = select_pose.from_client()
local function system()
	-- for _, player, pose_kind, order_id in from_client.iter() do
	-- 	try_select_pose(player, pose_kind :: t.rouber_pose_t, order_id)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
