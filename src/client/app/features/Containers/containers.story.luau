local ReplicatedStorage = game:GetService("ReplicatedStorage")
local container_variant1 = require(script.Parent.container_variant1)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px

local function story()
	use_px.use_px()
	return frame {
		color = Color3.fromRGB(0, 100, 200),

		size = UDim2.new(1, 0, 1, 0),
		container_variant1 {
			size = function()
				return UDim2.new(0, px(480 * 2), 0, px(320 * 2))
			end,
			cardx_size = function()
				return px(400)
			end,
			sidebar_size = function()
				return px(72)
			end,
			exit = function()
				print("exiting the menu")
			end,
		},
	}
end

return function(target: Folder)
	return vide.mount(story, target)
end
