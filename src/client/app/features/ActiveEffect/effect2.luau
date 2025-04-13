-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets            = require(ReplicatedStorage.assets)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local use_motion        = require(ReplicatedStorage.client.app.utility.use_motion)

type props = {}

local function effect2(props: props): { any }
  local top          = assets.images["ActiveBackground2.svg"]
  local bottom       = assets.images["ActiveBackground1.svg"]
  local pos1, mp1    = use_motion(UDim2.new(0.5, 0, 0.5 - 0.25, 0))
  local pos2, mp2    = use_motion(UDim2.new(0.5, 0, 0.5 + 0.25, 0))
  local sz1, ms1     = use_motion(UDim2.new(1, 0, 1.5, 0))
  local sz2, ms2     = use_motion(UDim2.new(0.85, 0, 1.45, 0))

	local configs = {
    repeatCount = -1,
    direction   = Enum.EasingDirection.InOut,
    reverses    = true,
    style       = Enum.EasingStyle.Linear,
    time        = 0.35,
	}
	-- stylua: ignore end

	local anchor = function()
		return Vector2.new(0.5, 0.5)
	end
	local bottom_color = function()
		return Color3.fromHex("#fcba03")
	end
	local top_color = function()
		return Color3.fromHex("#fcf003")
	end

	mp1:tween(UDim2.new(0.5, 0, 0.5, 0), configs)
	mp2:tween(UDim2.new(0.5, 0, 0.5, 0), configs)
	ms1:tween(UDim2.new(0.85, 0, 1.45, 0), configs)
	ms2:tween(UDim2.new(0.9, 0, 1.25, 0), configs)

	return {
		baseimage {
			img = bottom,
			size = sz1,
			transparency = function()
				return 0.25
			end,
			pos = pos1,
			anchor = anchor,
			color = bottom_color,
		},
		baseimage {
			img = top,
			size = sz2,
			transparency = function()
				return 0.2
			end,
			anchor = anchor,
			pos = pos2,
			color = top_color,
		},
	}
end

return effect2
