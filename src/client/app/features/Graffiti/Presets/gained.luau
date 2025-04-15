-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local hlayout           = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local sp_graffiti       = require(ReplicatedStorage.client.app.features.Graffiti.sp_graffiti)
local use_motion        = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local next_order        = require(ReplicatedStorage.common.utility.next_order)
local types             = require(ReplicatedStorage.types)

local px                = use_px.px
-- stylua: ignore end

--[[
  We can look to add some kind of offset algorithm, or tweak it up a bit idk
]]

local function text(props: {
	transparency: types.Source<number>?,
})
	local text = "GaiNED!"

	local letters = {}
	local order = next_order()

	for i = 1, #text do
		local curr_letter = text:sub(i, i)

		table.insert(
			letters,
			pane {
				size = function()
					return UDim2.new(0, px(48), 1, 0)
				end,
				sp_graffiti {
					letter = function()
						return curr_letter
					end,
					primary_color = Color3.fromRGB(255, 200, 0),
					secondar_color = Color3.fromRGB(),
					order = function()
						return order()
					end,
					thickness = function()
						return px(12)
					end,
					italic = true,
					transparency = props.transparency,
					stransparency = props.transparency,
				},
			}
		)
	end

	return pane {
		hlayout {},
		letters,
	}
end

local function graffiti_effect(props)
	local start_pos = UDim2.new(0.5, 0, 0.5, 0)
	local config = {
		delayTime = 1,
		direction = Enum.EasingDirection.InOut,
		repeatCount = -1,
		reverses = false,
		style = Enum.EasingStyle.Linear,
		time = 0.45,
	}

	local p1, pm1 = use_motion(start_pos)
	local p2, pm2 = use_motion(start_pos)
	local tt, ttm1 = use_motion(0)
	local rot = -5

	ttm1:tween(1, config)
	pm1:tween(UDim2.new(0, 0, 0.5, 0), config)
	pm2:tween(UDim2.new(1, 0, 0.5, 0), config)

	return {
		pane {
			rotation = rot,
			pos = p1,
			text {
				transparency = tt,
			},
			anchor = Vector2.new(0.5, 0.5),
		},
		pane {
			rotation = rot,
			pos = p2,
			text {
				transparency = tt,
			},
			anchor = Vector2.new(0.5, 0.5),
		},
		pane {
			rotation = rot,
			pos = start_pos,
			text {},
			anchor = Vector2.new(0.5, 0.5),
		},
	}
end

return graffiti_effect
