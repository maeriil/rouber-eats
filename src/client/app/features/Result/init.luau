-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local result_conditions = require(ReplicatedStorage.client.app.features.Result.result_conditions)
local result_exp        = require(ReplicatedStorage.client.app.features.Result.result_exp)
local result_lines      = require(ReplicatedStorage.client.app.features.Result.result_lines)
local result_money      = require(ReplicatedStorage.client.app.features.Result.result_money)
local result_sources    = require(ReplicatedStorage.client.app.features.Result.result_sources)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)

local px                = use_px.px
-- stylua: ignore end

local function result(props)
-- stylua: ignore start
  local animate_lines = result_sources.animate_lines
  local conditions    = result_sources.conditions
  local money         = result_sources.money
  local currexp       = result_sources.currexp
  local maxexp        = result_sources.maxexp
  local currlevel     = result_sources.currlevel
	-- stylua: ignore end

	--TODO: the UI might be too big, be careful
	local condition_size = function()
		return UDim2.new(0, px(800), 0, px(480))
	end

	local money_size = function()
		return UDim2.new(0, px(420), 0, px(256))
	end

	local exp_size = function()
		return UDim2.new(0, px(420), 0, px(256))
	end

	local condition_pos = function()
		return UDim2.new(0.5, -px(200), 0.5, -px(150))
	end

	local money_pos = function()
		return UDim2.new(0.2, -px(100), 0.5, px(64))
	end

	local exp_pos = function()
		return UDim2.new(0.5, px(200), 1, px(16))
	end

	return pane {
		result_lines {
			animate = animate_lines,
		},
		pane {
			rotation = -2,
			size = condition_size,
			anchor = function()
				return Vector2.new(0, 0.5)
			end,
			pos = condition_pos,
			result_conditions {
				conditions = conditions,
			},
		},
		pane {
			rotation = 5,
			size = money_size,
			anchor = function()
				return Vector2.new(0.5, 0.5)
			end,
			pos = money_pos,
			result_money {
				money = money,
			},
		},
		pane {
			size = exp_size,
			anchor = function()
				return Vector2.new(0.5, 1)
			end,
			pos = exp_pos,
			result_exp {
				currexp = currexp,
				currlevel = currlevel,
				maxexp = maxexp,
			},
		},
	}
end

return result
