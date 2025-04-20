-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local use_motion        = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)
local types             = require(ReplicatedStorage.types)

local px                = use_px.px
local create            = vide.create
local effect            = vide.effect
-- stylua: ignore end

local function result_lines(props: {
	animate: types.Source<boolean>,
})
	local core_size_1 = Vector2.new(1273, 514)
	local size_1 = function()
		return UDim2.new(0, px(core_size_1.X), 0, px(core_size_1.Y))
	end

	local core_size_2 = Vector2.new(1362, 481)
	local size_2 = function()
		return UDim2.new(0, px(core_size_2.X), 0, px(core_size_2.Y))
	end

	local config = {
		delayTime = 0,
		direction = Enum.EasingDirection.InOut,
		repeatCount = 0,
		reverses = false,
		style = Enum.EasingStyle.Linear,
		time = 0.5,
	}

	local t1, t1m = use_motion(1)
	local t2, t2m = use_motion(-1)

	effect(function()
		if props.animate() then
			t1m:tween(-1, config)
			t1m:onComplete(function(value: number)
				t2m:tween(1, config)
			end)
		end
	end)

	return pane {
		pane {
			size = size_1,
			pos = function()
				return UDim2.new(0, 0, 0, px(192))
			end,
			baseimage {
				img = assets.images["result_screen_vec_top_1.svg"],
				create "UIGradient" {
					Transparency = NumberSequence.new {
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.2, 1),
						NumberSequenceKeypoint.new(0.20001, 0),
						NumberSequenceKeypoint.new(1, 0),
					},
					Offset = function()
						return Vector2.new(t1(), 0)
					end,
				},
			},
		},

		pane {
			size = size_2,
			pos = function()
				return UDim2.new(0, 0, 1, 0)
			end,
			anchor = Vector2.new(0, 1),
			baseimage {
				img = assets.images["result_screen_vec_top_2.svg"],
				size = size_2,
				create "UIGradient" {
					Transparency = NumberSequence.new {
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(0.2, 1),
						NumberSequenceKeypoint.new(0.20001, 0),
						NumberSequenceKeypoint.new(1, 0),
					},
					Offset = function()
						return Vector2.new(t2(), 0)
					end,
					Rotation = function()
						return 180
					end,
				},
			},
		},
	}
end

return result_lines
