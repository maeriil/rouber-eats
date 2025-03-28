local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local ratio = require(ReplicatedStorage.client.app.components.ratio)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local viewport = require(ReplicatedStorage.client.app.components.viewport)

local px = use_px.px
local create = vide.create

-- type props = {
-- 	model: Model,
-- }

local function DialgoueAvatar(props: pane.props & {
	model: Model,
})
	return pane {
		size = props.size or function()
			-- return UDim2.new(0, px(250), 0, px(175))
			return UDim2.new(1, 0, 1, 0)
		end,
		pos = props.pos,
		anchor = props.anchor,
		ratio {
			ratio = 250 / 175,
		},

		create "ImageLabel" {
			Image = assets.images["DialogueProfile.svg"],
			-- Size = UDim2.new(0, px(250), 0, px(175)),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.fromRGB(255, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),

			pane {
				clips = true,
				size = function()
					return UDim2.new(0.65, 0, 0.75, 0)
				end,
				anchor = Vector2.new(1, 0),
				pos = function()
					return UDim2.new(1, -px(16), 0, 0)
				end,
				viewport {
					-- anchor = Vector2.new(0, 1),
					model = props.model,
					transform = CFrame.new() * CFrame.Angles(0, math.rad(180) + math.rad(20), 0),
					camera_position = CFrame.Angles(0, math.rad(-10), 0) * CFrame.new(0, 2, 2.5),
				},
			},
		},
	}
end

return DialgoueAvatar
