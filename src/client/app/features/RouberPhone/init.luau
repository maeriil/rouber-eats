local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ExitButton = require(ReplicatedStorage.client.app.features.Icons.ExitButton)
local assets = require(ReplicatedStorage.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local go_back_page = require(ReplicatedStorage.client.app.utility.go_back_page)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px
local create = vide.create

type props = {
	[number]: any,
}

local scaled_1080p_size = Vector2.new(709, 1070)
local inner_content_size = Vector2.new(492, 835)
local offset = 58

local function phone(props: props)
	local order = next_order()
	local exit = go_back_page

	return pane {
		size = function()
			return UDim2.fromOffset(px(scaled_1080p_size.X), px(scaled_1080p_size.Y))
		end,
		pos = function()
			return UDim2.new(0.75, 0, 1, px(offset)) --44
		end,
		anchor = Vector2.new(0.75, 1),

		create "ImageLabel" {
			ImageTransparency = 0,
			BackgroundTransparency = 1,
			Image = assets.images["PhoneDesign1.svg"],
			Size = function()
				return UDim2.fromOffset(px(scaled_1080p_size.X), px(scaled_1080p_size.Y))
			end,

			ExitButton {
				click = exit,
				anchor = function()
					return Vector2.new(0.5, 0.5)
				end,
				pos = function()
					return UDim2.new(1, -px(16 * 2), 0, px(16 * 8 + offset))
				end,
			},

			frame {
				color = Color3.fromRGB(255, 0, 0),
				transparency = 0.45,
				name = "Content",
				size = function()
					return UDim2.fromOffset(px(inner_content_size.X), px(inner_content_size.Y))
				end,
				rotation = -4,
				anchor = Vector2.new(0.5, 0.5),
				pos = function()
					return UDim2.new(0.5, -px(offset / 5.5), 0.5, px(offset / 5))
				end,

				unpack(props),
			},
		},
	}
end

return phone
