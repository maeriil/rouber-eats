local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local rtext = require(ReplicatedStorage.client.app.components.text.rtext)
local backpack_image_card =
	require(ReplicatedStorage.client.app.pages.BackpackScreen.backpack_image_card)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local colorscheme = require(ReplicatedStorage.client.store.colorscheme)
local vide = require(ReplicatedStorage.pkg.vide)

local values = vide.values
local px = use_px.px
local create = vide.create

local function backpack_poses(props)
	local my_poses = uistore.backpack_poses
	local card_size = function()
		return UDim2.new(0, px(156), 0, px(156))
	end

	my_poses({
		{ display_name = "A little long name", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
		{ display_name = "Hello", pose_image = assets.images["TaxiAppIcon.svg"] },
	})

	return pane {
		create "ScrollingFrame" {
			BackgroundColor3 = Color3.fromRGB(0, 0, 255),
			BackgroundTransparency = 1,
			Size = function()
				return UDim2.new(1, -px(48 * 2), 1, -px(32 * 2))
			end,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ClipsDescendants = true,

			--[[
				TODO: Honestly this is a very dirty way of doing grid list.
				The reason is because this makes it so that no matter what device you select, you
				always have 5 items in a row(0.2 * 5 = 1.0). But we shouldn't want to do this!
				In a smaller screen size, we should show less items per row and instead make the
				frame size bigger!

				This is a minor enhancement tbh so won't be doing it yet
			]]
			create "UIGridLayout" {
				CellPadding = function()
					return UDim2.new(0, px(32), 0, px(32))
				end,
				CellSize = function()
					return UDim2.new(0.22, 0, px(196), 0)
				end,
				StartCorner = Enum.StartCorner.TopLeft,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
				create "UIAspectRatioConstraint" {
					AspectRatio = 1.0,
					AspectType = Enum.AspectType.ScaleWithParentSize,
				},
			},

			values(my_poses, function(content, order: () -> number)
				return pane {
					size = card_size,
					order = order,
					pane {
						backpack_image_card {
							image = function()
								return content.pose_image
							end,
						},
					},
					frame {
						color = colorscheme.matte_black,
						size = function()
							return UDim2.new(1, 0, 0, px(52))
						end,
						anchor = Vector2.new(0.5, 1),
						pos = function()
							return UDim2.new(0.5, 0, 1, 0)
						end,
						rtext {
							text = function()
								return content.display_name
							end,
							bolded = false,
							wrap = true,
							color = function()
								return colorscheme.warm_white
							end,
						},
					},
				}
			end),
		},
	}
end

return backpack_poses
