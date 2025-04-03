local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
--[[
  This module just contains basically conditions for a player to reach this
  rating.

  Some of these conditions can be permanent, or even temporary
]]

local conditions: types.RatingConfigConditionType = {
	min_orders_altered = 0,
	min_orders_delivered = 1000000,
	min_orders_stolen = 0,

	min_orders_with_4_star_customer_feedback = 0,
	min_orders_with_5_star_customer_feedback = 0,
}

local config: types.RatingConfigType = {
	conditions = conditions,
}

return config
