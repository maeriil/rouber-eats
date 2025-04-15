-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vlayout           = require(ReplicatedStorage.client.app.components.layouts.vlayout)
local padding_types     = require(ReplicatedStorage.client.app.components.padding.padding_types)
local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local pane              = require(ReplicatedStorage.client.app.components.pane.pane)
local result_exp        = require(ReplicatedStorage.client.app.features.Result.result_exp)
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
				return UDim2.new(0, px(420), 0, px(256))
			end,
			result_exp {
				currexp = function()
					return 1000
				end,
				maxexp = function()
					return 10000
				end,
				currlevel = function()
					return 54
				end,
			},
		},
		frame {
			color = Color3.fromRGB(0, 200, 0),
			size = function()
				return UDim2.new(0, px(560), 0, px(256))
			end,
			result_exp {
				currexp = function()
					return 999
				end,
				maxexp = function()
					return 1100
				end,
				currlevel = function()
					return 9
				end,
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
