local ReplicatedStorage = game:GetService("ReplicatedStorage")

local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local HintSection = require(ReplicatedStorage.client.app.pages.PosesScreen.HintSection)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount

local function story()
	return {
		pane {
			size = UDim2.new(0, 500, 0, 500),
			anchor = Vector2.new(0.5, 0.5),
			pos = UDim2.new(0.5, 0, 0.5, 0),
			HintSection {
				hint = function()
					return `JohnDoe likes <stroke color="#00A2FF">flashy poses</stroke> but he hates poses with <stroke color="#FF0000">props!</stroke>`
				end,
			},
		},
	}
end

return function(target)
	return mount(story, target)
end
