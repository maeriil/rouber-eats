local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
--[[
  This module just contains basically conditions for a player to reach this
  rating.

  Some of these conditions can be permanent, or even temporary
]]

local conditions: types.RatingConfigConditionType = {
	min_orders_altered = 0,
	min_orders_delivered = 1,
	min_orders_stolen = 0,

	min_orders_with_4_star_customer_feedback = 0,
	min_orders_with_5_star_customer_feedback = 0,
}

local config: types.RatingConfigType = {
	conditions = conditions,
	high_tier_order_weights = { 1, 0.36, 0.60, 0.25, 0.08, 0.01 },
	regular_tier_order_weights = { 1, 0.25, 0.05, 0, 0, 0 },
	high_tier_base_coins = { 120, 150, 220, 280, 490, 800 },
	regular_tier_base_coins = { 50, 85, 120, 0, 0, 0 },
}

return config
