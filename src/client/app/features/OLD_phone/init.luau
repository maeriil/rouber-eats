-- NOT DELETING THIS BECAUSE I SPENT 13 HOURS ON THIS :(

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local assets = require(ReplicatedStorage.assets)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local next_order = require(ReplicatedStorage.common.utility.next_order)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local phonebase = require(script.phonebase)
local phonesidebar = require(script.phonesidebar)
local ripple = require(ReplicatedStorage.pkg.ripple)
local showdelay = require(ReplicatedStorage.client.app.components.showdelay)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local effect = vide.effect
local source = vide.source
local cleanup = vide.cleanup
local create = vide.create
local px = use_px.px
local show = vide.show

local function phone(props)
	local config = { tension = 300, friction = 12 }
	local animate = source(false)
	local red_color = Color3.fromRGB(255, 0, 0)
	local order = next_order()

	local mainsidebar, mainsidebar_motion = use_motion(2)
	local sidesidebar, sideside_motion = use_motion(-2)
	local mainframemove, mainframemove_motion = use_motion(2)
	local titlemove, titlemove_motion = use_motion(-1)
	local total_time = 50

	-- cleanup(RunService.Heartbeat:Connect(function(dt: number)
	-- 	currdt(dt * speed + currdt())
	-- 	print(currdt())
	-- end))

	local tilemovement, tilemovement_motion = use_motion(0)
	local tilemovement_secondary, tilemovementsecondary_motion = use_motion(-1000)

	effect(function()
		if uistore.ShowPhone() then
			animate(true)
			tilemovement_motion:tween(-1000, {
				direction = Enum.EasingDirection.Out,
				repeatCount = -1,
				style = Enum.EasingStyle.Linear,
				reverses = false,
				time = total_time,
			})
			tilemovementsecondary_motion:tween(0, {
				direction = Enum.EasingDirection.Out,
				repeatCount = -1,
				style = Enum.EasingStyle.Linear,
				reverses = false,
				time = total_time,
			})
		else
			animate(false)
			tilemovement_motion:stop()
			tilemovementsecondary_motion:stop()
		end
	end)

	effect(function()
		if animate() then
			mainsidebar_motion:spring(0, config)
			sideside_motion:spring(0, config)
			mainframemove_motion:spring(1, config)
			titlemove_motion:spring(0, config)
		else
			mainsidebar_motion:spring(1, config)
			sideside_motion:spring(-1, config)
			mainframemove_motion:spring(2, config)
			titlemove_motion:spring(-1, config)
		end
	end)

	local pad_36_left = pane {
		color = Color3.fromRGB(0, 0, 255),
		size = function()
			return UDim2.new(0, 36, 1, 0)
		end,
		order = order(),
	}

	local empty = pane {
		color = Color3.fromRGB(0, 100, 100),
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		flexfill {},
		order = order(),
	}

	local no_pad = function()
		return UDim.new()
	end
	local content = pane {
		size = function()
			return UDim2.new(0, px(448), 1, 0)
		end,
		order = order(),
		-- color = Color3.fromRGB(255, 0, 0),
		create "ImageLabel" {
			ImageTransparency = 1,
			Image = assets.images["Sidebar_Side.png"],
			Size = function()
				return UDim2.new(0, px(39), 1, 0)
			end,
			Position = function()
				return UDim2.new(0, 0, sidesidebar(), 0)
			end,
			BackgroundTransparency = 1,
			show(animate, function()
				return pane {
					size = function()
						return UDim2.new(0, px(8), 1, 0)
					end,
					rotation = 4,
					anchor = Vector2.new(0.5, 0),
					pos = UDim2.new(0.5, 0, 0, 0),
					clips = true,

					create "ImageLabel" {
						Image = assets.images["SiderbarPattern.png"],
						Size = function()
							return UDim2.new(1, 0, 2, px(8 * 2000))
						end,
						Rotation = 0,
						BackgroundTransparency = 1,
						AnchorPoint = Vector2.new(1, 0),
						Position = function()
							return UDim2.new(1, 0, 0, tilemovement_secondary())
						end,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = function()
							return UDim2.new(0, px(8), 0, px(8))
						end,
					},
				}
			end),
		},
		frame {
			size = function()
				return UDim2.new(0, px(405), 1, 0)
			end,
			pos = function()
				return UDim2.new(mainframemove(), 0, 0, 0)
			end,
			anchor = function()
				return Vector2.new(1, 0)
			end,
			color = Color3.fromRGB(255, 0, 0),
		},
		create "ImageLabel" {
			ImageTransparency = 1,
			Image = assets.images["Sidebar_Main.png"],
			Size = function()
				return UDim2.new(0, px(86), 1, 0)
			end,
			Position = function()
				return UDim2.new(0, px(39 - 30), mainsidebar(), 0)
			end,
			BackgroundTransparency = 1,
			show(animate, function()
				return pane {
					size = function()
						return UDim2.new(0, px(56), 1, 0)
					end,
					rotation = 4,
					anchor = Vector2.new(0.5, 0),
					pos = UDim2.new(0.5, 0, 0, 0),
					clips = true,

					create "ImageLabel" {
						Image = assets.images["SiderbarPatternInverted.png"],
						Size = function()
							return UDim2.new(1, 0, 2, px(56 * 2000))
						end,
						BackgroundTransparency = 1,
						Rotation = 0,
						AnchorPoint = Vector2.new(1, 0),
						Position = function()
							return UDim2.new(1, 0, 0, tilemovement())
						end,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = function()
							return UDim2.new(0, px(56), 0, px(56))
						end,
					},
				}
			end),
		},
		create "ImageLabel" {
			ImageTransparency = 1,
			Image = assets.images["Sidebar_Side.png"],
			Size = function()
				return UDim2.new(0, px(39), 1, 0)
			end,
			Position = function()
				return UDim2.new(0, px(86 + 9 - 30), sidesidebar(), 0)
			end,
			BackgroundTransparency = 1,
			show(animate, function()
				return pane {
					size = function()
						return UDim2.new(0, px(8), 1, 0)
					end,
					rotation = 4,
					anchor = Vector2.new(0.5, 0),
					pos = UDim2.new(0.5, 0, 0, 0),
					clips = true,

					create "ImageLabel" {
						Image = assets.images["SiderbarPattern.png"],
						BackgroundTransparency = 1,
						Size = function()
							return UDim2.new(1, 0, 2, px(8 * 2000))
						end,
						Rotation = 0,
						AnchorPoint = Vector2.new(1, 0),
						Position = function()
							return UDim2.new(1, 0, 0, tilemovement_secondary())
						end,
						ScaleType = Enum.ScaleType.Tile,
						TileSize = function()
							return UDim2.new(0, px(8), 0, px(8))
						end,
					},
				}
			end),
		},

		create "ImageLabel" {
			Image = assets.images["Order_List_Back.png"],
			Size = function()
				return UDim2.new(0, px(350), 0, px(379))
			end,
			Position = function()
				return UDim2.new(mainframemove(), 0, 1, 0)
			end,
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = assets.images["Order_List_Front.png"],
			Size = function()
				return UDim2.new(0, px(344), 0, px(345))
			end,
			Position = function()
				return UDim2.new(mainframemove(), -px(13), 1, -px(23))
			end,
			AnchorPoint = Vector2.new(1, 1),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = assets.images["Title_Back.png"],
			Size = function()
				return UDim2.new(0, px(228.5), 0, px(57.5))
			end,
			Position = function()
				return UDim2.new(1, -px(17), titlemove(), px(15))
			end,
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
		},
		create "ImageLabel" {
			Image = assets.images["Title_Front.png"],
			Size = function()
				return UDim2.new(0, px(196), 0, px(40))
			end,
			Position = function()
				return UDim2.new(1, -px(30), titlemove(), px(25))
			end,
			AnchorPoint = Vector2.new(1, 0),
			BackgroundTransparency = 1,
		},
	}
	local pad_36_right = frame {
		size = function()
			return UDim2.new(0, 36, 1, 0)
		end,

		color = red_color,
		order = order(),
	}

	-- local pad_36_right = show(animate, function()
	-- 	return frame {
	-- 		size = function()
	-- 			return UDim2.new(0, 36, 1, 0)
	-- 		end,

	-- 		color = red_color,
	-- 		order = order(),
	-- 	}
	-- end)

	local frame = pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		hlayout {
			pad = no_pad,
		},
		pad_36_left,
		empty,
		content,
		pad_36_right,
	}

	return showdelay(function()
		return frame
	end, uistore.ShowPhone, 1) {}
end

return phone
