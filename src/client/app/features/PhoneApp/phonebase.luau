local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
local px = use_px.px

local function basephone(props)
	return create "Frame" {
		Size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		hlayout {
			halign = Enum.HorizontalAlignment.Right,
			pad = function()
				return UDim.new()
			end,
		},
		create "Frame" {
			Size = function()
				return UDim2.new(0, px(350.5), 0, px(1440))
			end,
			LayoutOrder = 1,
			-- ClipsDescendants = true,
			BackgroundTransparency = 1,
			create "ImageLabel" {
				Image = assets.images["SideBar.png"],
				Size = function()
					return UDim2.new(0, px(351), 0, px(1440))
					-- return UDim2.new(0.5, 0, 1, 0)
				end,
				Position = UDim2.new(0, px(92), 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				-- ZIndex = ,
			},
		},

		create "Frame" {
			Size = function()
				return UDim2.new(0, px(1280), 0, px(1440))
			end,
			BackgroundColor3 = Color3.fromRGB(0, 255, 0),
			ClipsDescendants = true,
			Position = UDim2.new(1, 0, 0.5, 0),
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundTransparency = 1,
			LayoutOrder = 1,

			create "ImageLabel" {
				Image = assets.images["PhoneFrameMain.png"],
				Size = function()
					return UDim2.new(0, px(1305), 0, px(1534))
					-- return UDim2.new(0.5, 0, 1, 0)
				end,
				Position = UDim2.new(0, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0, 0.5),
				BackgroundTransparency = 1,
				-- ImageTransparency = 1,
			},
		},
	}
end

return basephone
