local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local assets = require(ReplicatedStorage.assets.assets)
local billboard = require(ReplicatedStorage.client.app.components.billboard)
local circle = require(ReplicatedStorage.client.app.components.corner.circle)
local baseimage = require(ReplicatedStorage.client.app.components.image.baseimage)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local square = require(ReplicatedStorage.client.app.components.ratio.square)
local srtext = require(ReplicatedStorage.client.app.components.text.srtext)
local viewport = require(ReplicatedStorage.client.app.components.viewport)
local uistore = require(ReplicatedStorage.client.app.uistore)
local use_motion = require(ReplicatedStorage.client.app.utility.use_motion)
local vide = require(ReplicatedStorage.pkg.vide)

local create = vide.create
--[[
  We use pose 1 to display the following things
    Scene 1:
    - Some pose text
    Scene 2:
    - Conditions Checklist
    Scene 3:
    - Roubins, Rating

  Finally, we need to perform unmount animation and move on to the next stage

  The background of Scene 1 is entirely Billboard UI except the pose text
  Then in the Scene 2, we will add a second layer of frames and display the req ones
  Then in the Scene 3, we will add a third layer of frames and display the req ones
  Finally we will unmount and tween out all the frames
]]

local function star(props)
	return baseimage {
		img = assets.images["ActiveStar.svg"],
	}
end

local function display(props)
	local stpos, stposm = use_motion(UDim2.new(2, 0, 0.5, 0))
	local textpos, textposm = use_motion(UDim2.new(0.75, 0, 0, 0))
	local rot, rotm = use_motion(90)
	local currmodel = uistore.MyModel()
	local config = {
		delayTime = 0,
		direction = Enum.EasingDirection.InOut,
		repeatCount = 0,
		reverses = false,
		style = Enum.EasingStyle.Elastic,
		time = 1,
	}
	textposm:tween(UDim2.new(0.5, 0, 0, 0))
	stposm:tween(UDim2.new(0, 0, 0.5, 0), config)
	rotm:tween(0, config)
	return {
		frame {
			color = Color3.fromRGB(0, 180, 250),

			frame {
				size = function()
					return UDim2.new(1.5, 0, 0.9, 0)
				end,
				rotation = 10,
				pos = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				anchor = Vector2.new(0.5, 0.5),
				pane {
					size = function()
						return UDim2.new(0.75, 0, 0.25, 0)
					end,
					anchor = Vector2.new(0.5, 0),
					pos = textpos,
					srtext {
						text = function()
							return `POSE FOR THE FAN`
						end,
						xbolded = true,
						italic = true,
					},
				},
			},
			frame {
				size = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				square {},
				circle {},
				transparency = 0.75,
				pos = UDim2.new(0, 0, 1, 0),
				anchor = Vector2.new(0.5, 1),
			},
			frame {
				size = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				square {},
				circle {},
				transparency = 0.75,
				pos = UDim2.new(0, 0, 1, 0),
				anchor = Vector2.new(0, 1),
			},
			pane {
				color = Color3.fromRGB(255, 0, 255),
				size = function()
					return UDim2.new(0.5, 0, 0.5, 0)
				end,
				rotation = rot,
				pos = stpos,
				anchor = Vector2.new(0, 0.5),
				square {},
				star {},
			},
			frame {
				name = "grayscale-filter-test",
				color = function()
					return Color3.fromRGB(70, 70, 70)
				end,
				transparency = function()
					return 0.05
				end,
				anchor = Vector2.new(0.5, 0.5),
				pos = UDim2.new(0.5, 0, 0.5, 0),
			},
			pane {
				size = function()
					return UDim2.new(0.5, 0, 1, 0)
				end,
				pos = function()
					return UDim2.new(1, 0, 0, 0)
				end,
				anchor = Vector2.new(1, 0),
				viewport {
					model = currmodel,
					camera_position = CFrame.new(0, 0, 0)
						* CFrame.Angles(math.rad(-5), 0, 0)
						* CFrame.new(0, 4, 3.5),
					transform = CFrame.new() * CFrame.Angles(0, math.rad(180) - math.rad(5), 0),
				},
			},
		},
	}
end

return display
