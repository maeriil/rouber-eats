-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets            = require(ReplicatedStorage.assets.assets)
local flexfill          = require(ReplicatedStorage.client.app.components.flex.flexfill)
local baseimage         = require(ReplicatedStorage.client.app.components.image.baseimage)
local hlayout           = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext             = require(ReplicatedStorage.client.app.components.text.rtext)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local poses             = require(ReplicatedStorage.common.configs.poses)
local poses_category    = require(ReplicatedStorage.common.configs.poses_category)
local vide              = require(ReplicatedStorage.pkg.vide)
local types             = require(ReplicatedStorage.types)

local px   = use_px.px
local show = vide.show

type props = {
  pose   : () -> types.rouber_pose_t,
  blur   : () -> boolean,
  active : () -> boolean,
}
-- stylua: ignore end

local function pose_entry(props: props): { any }
	local pose_details = function()
		local pose = props.pose()
		local details = poses[pose :: never]

		return details
	end

	local category_details = function()
		local pose = props.pose()
		local category = poses[pose :: never].category
		local details = poses_category[category :: never]
		return details
	end

	local textcolor = function()
		return if props.active() then Color3.fromRGB(60, 60, 60) else Color3.fromRGB(240, 240, 240)
	end

	local blur_transparency = function()
		return if props.blur() then 0.75 else 0
	end

	local icon_size = 64

	return {
		hlayout {},
		frame {
			size = function()
				return UDim2.new(0, px(96), 1, 0)
			end,
			order = 1,
			color = Color3.fromRGB(60, 60, 60),
			transparency = function()
				return if props.active() then 0.15 else 1
			end,
			baseimage {
				img = function()
					return category_details().display_image
				end,
				transparency = blur_transparency,
			},
		},
		pane {
			color = Color3.fromRGB(0, 255, 0),
			order = 2,
			flexfill {},
			rtext {
				text = function()
					return pose_details().display_name
				end,
				bolded = true,
				color = textcolor,
				size = "sm",
				ttransparency = blur_transparency,
			},
			show(props.blur, function()
				return pane {
					size = function()
						return UDim2.new(1.5, 0, 1.5, 0)
					end,
					anchor = Vector2.new(0.5, 0.5),
					pos = UDim2.new(0.5, 0, 0.5, 0),
					baseimage {
						img = function()
							return assets.images["blur.png"]
						end,
						transparency = function()
							return 0
						end,
						color = function()
							return Color3.fromRGB(150, 150, 150)
						end,
					},
				}
			end),
		},
		pane {
			color = Color3.fromRGB(0, 255, 255),
			order = 3,
			size = function()
				return UDim2.new(0, px(96), 1, 0)
			end,
			rtext {
				text = function()
					return `{pose_details().rating}*`
				end,
				bolded = true,
				italic = true,
				size = "sm",
				color = textcolor,
				ttransparency = blur_transparency,
			},
		},
	}
end

return pose_entry
