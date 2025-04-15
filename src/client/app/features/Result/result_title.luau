local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local srtext = require(ReplicatedStorage.client.app.components.text.srtext)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)

local px = use_px.px

type props = {
	looped: boolean?,
}

local function result_title(props: props): { any }
	local function text_panel_size()
		return UDim2.new(0.8, 0, 0.5, 0)
	end
	local function primary_text_color()
		return Color3.fromRGB(0, 0, 255)
	end
	local function secondary_text_color()
		return Color3.fromRGB(0, 150, 255)
	end
	local function blur_background()
		return Color3.fromRGB(255, 255, 255)
	end
	local offset = 256
	local tween_config1 = {
		direction = Enum.EasingDirection.InOut,
		style = Enum.EasingStyle.Linear,
		delayTime = 0,
		repeatCount = 0,
		reverses = false,
		time = 1,
	}

	local p1, pm1 = use_motion(UDim2.new(0.5, -px(offset), 0.5, 0))
	local p2, pm2 = use_motion(UDim2.new(0.5, px(offset), 0.5, 0))
	local t1, tm1 = use_motion(0)
	local t2, tm2 = use_motion(0)
	pm1:tween(UDim2.new(0.5, -px(offset), 0.2, 0), tween_config1)
	pm2:tween(UDim2.new(0.5, px(offset), 0.8, 0), tween_config1)
	tm1:tween(0.8, tween_config1)
	tm1:onComplete(function(value: number)
		tm1:tween(1, tween_config1)
		tm2:tween(1, tween_config1)
	end)

	return {
		pane {
			size = function()
				return UDim2.new(1.45, 0, 0.75, 0)
			end,
			pos = function()
				return UDim2.new(0.5, 0, 0.5, 0)
			end,
			anchor = Vector2.new(0.5, 0.5),
			baseimage {
				img = assets.images["blur.png"],
				color = blur_background,
				transparency = t1,
			},
		},
		pane {
			size = function()
				return UDim2.new(1.45, 0, 0.75, 0)
			end,
			pos = function()
				return UDim2.new(0.5, 0, 0.5, 0)
			end,
			anchor = Vector2.new(0.5, 0.5),
			rotation = 10,
			baseimage {
				img = assets.images["blur.png"],
				color = function()
					return Color3.fromRGB(200, 0, 200)
				end,
				transparency = t2,
			},
		},
		pane {
			size = text_panel_size,
			pos = p1,
			anchor = Vector2.new(0.5, 0.5),
			rotation = -10,
			srtext {
				text = function()
					return `RESULT TIME!`
				end,
				xbolded = true,
				italic = true,
				color = secondary_text_color,
				ttransparency = t1,
			},
		},
		pane {
			size = text_panel_size,
			pos = p2,
			anchor = Vector2.new(0.5, 0.5),
			rotation = -10,
			srtext {
				text = function()
					return `RESULT TIME!`
				end,
				xbolded = true,
				italic = true,
				color = secondary_text_color,
				ttransparency = t1,
			},
		},
		pane {
			size = text_panel_size,
			pos = function()
				return UDim2.new(0.5, 0, 0.5, 0)
			end,
			anchor = Vector2.new(0.5, 0.5),
			rotation = -10,
			srtext {
				text = function()
					return `RESULT TIME!`
				end,
				xbolded = true,
				italic = true,
				color = primary_text_color,
				ttransparency = t2,
			},
		},
	}
end

return result_title
