local ReplicatedStorage = game:GetService("ReplicatedStorage")
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local vide = require(ReplicatedStorage.pkg.vide)
local viewport = require(script.Parent)

local cleanup = vide.cleanup
local mount = vide.mount

local function story()
	local noob = workspace:FindFirstChild("Noob"):Clone()
	cleanup(noob)

	return frame {
		size = function()
			return UDim2.new(0, 300, 0, 300)
		end,
		pos = UDim2.fromScale(0.5, 0.5),
		anchor = Vector2.new(0.5, 0.5),
		viewport {
			model = noob,
		},
	}
end

return function(target)
	return mount(story, target)
end
