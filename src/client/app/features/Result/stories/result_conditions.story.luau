-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vlayout           = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local result_conditions = require(ReplicatedStorage.client.app.features.Result.result_conditions)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)

local mount             = vide.mount
local px                = use_px.px
-- stylua: ignore end

--[[
  Something to note is that we should never let people get to 100m area. Like i want to say
  like super late game, a million -> 10 million range is more reasonable
]]

local function story()
	use_px.use_px()
	return frame {
		vlayout {
			pad = padding_types.px16,
		},

		frame {
			color = Color3.fromRGB(0, 200, 0),
			size = function()
				return UDim2.new(0, px(800), 0, px(480))
			end,
			result_conditions {
				conditions = function()
					return {
						{ text = "Clear the stage", success = true },
						{ text = "Clear within 2 minutes", success = true },
						{ text = "Collected all the coins", success = false },
					}
				end,
			},
		},
		frame {
			color = Color3.fromRGB(0, 200, 0),
			size = function()
				return UDim2.new(0, px(800), 0, px(480))
			end,
			result_conditions {
				conditions = function()
					return {
						{ text = "Clear the stage", success = true },
						{ text = "Clear within 2 minutes", success = true },
						{ text = "Collected all the coins", success = false },
						{ text = "Maximum of 4 conditions?", success = false },
						{ text = "what happens on 5th?", success = false },
					}
				end,
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
