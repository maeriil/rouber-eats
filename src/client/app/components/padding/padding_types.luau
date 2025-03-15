local ReplicatedStorage = game:GetService("ReplicatedStorage")
local use_px = require(ReplicatedStorage.client.app.utility.use_px)

local px = use_px.px

local function get_value(num: number, do_not_use_px: boolean?)
	return if do_not_use_px then num else px(num)
end

return {
	nopad = function()
		return UDim.new()
	end,
	px4 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(4, do_not_use_px))
	end,
	px8 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(8, do_not_use_px))
	end,
	px12 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(12, do_not_use_px))
	end,
	px16 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(16, do_not_use_px))
	end,
	px32 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(32, do_not_use_px))
	end,
	px36 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(36, do_not_use_px))
	end,
	px48 = function(do_not_use_px: boolean?)
		return UDim.new(0, get_value(48, do_not_use_px))
	end,
}
