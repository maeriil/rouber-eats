local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local ripple = require(ReplicatedStorage.pkg.ripple)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local vide = require(ReplicatedStorage.pkg.vide)

local spring = vide.spring
local action = vide.action
local source = vide.source
local effect = vide.effect

local function story()
	local start = source(false)
	local pos = spring(function()
		return if start() then UDim2.new(1, 0, 0.5, 0) else UDim2.new(0, 0, 0, 0)
	end, 0.3)

	local state, motion = use_motion(UDim2.new())
	local config = { tension = 300, friction = 12 }

	effect(function()
		if start() then
			motion:spring(UDim2.new(1, 0, 0.5, 0), config)
		end
	end)

	return frame {
		size = function()
			return UDim2.new(0, 100, 0, 100)
		end,
		-- pos = pos,
		pos = state,
		anchor = Vector2.new(1, 0.5),

		action(function(a0: Instance)
			start(true)
		end),
	}
end

return function(target)
	return vide.mount(story, target)
end
