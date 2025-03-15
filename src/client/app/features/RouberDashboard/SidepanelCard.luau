local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create

type props = {
	order: types.Can<number>,

	[number]: any,
}
-- original is what our original image size is when we uploaded to roblox
-- 127 pixels,
-- 89 pixels,  525-517   818-813

-- This scaled size is the downscaled size we used while laying out in figma at 1080p canvas
local scaled_1080p_size = Vector2.new(525, 818) -- Should be using this res

-- Our actuall content must fit inside this. We will need to add 16px padding on all sides too
local inner_content_size = Vector2.new(396, 640)

local offset_from_left = 16

local function SidepanelCard(props: props)
	return pane {
		zindex = 2,
		size = function()
			return UDim2.new(0, px(scaled_1080p_size.X + 16), 1, 0)
		end,
		create "ImageLabel" {
			ImageTransparency = 0,
			BackgroundTransparency = 1,
			-- BackgroundColor3 = Color3.fromRGB(0, 255, 0),
			Image = assets.images["CardEffect_test.svg"],
			Size = function()
				return UDim2.fromOffset(px(scaled_1080p_size.X + 16), px(scaled_1080p_size.Y + 16))
			end,
			Position = function()
				return UDim2.new(0, px(offset_from_left), 0.5, 0)
			end,
			AnchorPoint = Vector2.new(0, 0.5),
			pane {
				name = "Content",
				size = function()
					return UDim2.fromOffset(px(340), px(566)) -- Got directly from figma models
				end,
				-- color = Color3.fromRGB(255, 0, 0),
				-- transparency = 0,
				rotation = -4,
				anchor = Vector2.new(0.5, 0.5),
				pos = function()
					return UDim2.new(0.5, -px(4), 0.5, px(10))
				end,

				unpack(props),
			},
		},
	}
end

return SidepanelCard
