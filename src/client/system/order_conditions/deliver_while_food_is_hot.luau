-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)

local t = require(ReplicatedStorage.types)
local ct = require(ReplicatedStorage.types.config_types)
local p = require(ReplicatedStorage.common.ecs.pairs)
local c = require(ReplicatedStorage.common.ecs.components)
local tr = require(ReplicatedStorage.common.ecs.target)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard
-- stylua: ignore end

local start_tracking_query =
	world:query(c.DeliveryOrderDetails):with(p.Start(c.HotFoodCondition)):cached()

local stop_tracking = world:query(c.DeliveryOrderDetails):with(p.End(c.HotFoodCondition)):cached()

local function start_hot_food_condition()
	for order_id, details in start_tracking_query:iter() do
	end
end

local function system()
	--system
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
