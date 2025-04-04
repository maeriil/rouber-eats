local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
--[[
  This module just contains basically conditions for a player to reach this
  rating.

  Some of these conditions can be permanent, or even temporary
]]

local conditions: types.RatingConfigConditionType = {
	min_orders_altered = 0,
	min_orders_delivered = 6,
	min_orders_stolen = 0,

	min_orders_with_4_star_customer_feedback = 0,
	min_orders_with_5_star_customer_feedback = 0,
}

local config: types.RatingConfigType = {
	conditions = conditions,
	high_tier_order_weights = { 0, 0, 1, 0.55, 0.18, 0.06 },
	regular_tier_order_weights = { 0.85, 1, 0.45, 0, 0, 0 },
	high_tier_base_coins = { 0, 0, 300, 340, 490, 800 },
	regular_tier_base_coins = { 50, 85, 120, 180, 240, 290 },
}

return config
