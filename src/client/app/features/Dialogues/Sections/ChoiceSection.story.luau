local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChoiceSection = require(script.Parent.ChoiceSection)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local source = vide.source

local function story()
	use_px.use_px()
	local noob = workspace:FindFirstChild("Noob")
	local mae = workspace:FindFirstChild("Maeriil")

	local choices = source({
		{ id = 1, text = "Grab a glass of water" },
		{ id = 2, text = "Order a pizza" },
		{ id = 3, text = "Look for something else" },
	})

	return frame {
		transparency = 1,
		size = UDim2.new(0.5, 0, 1, 0),
		anchor = Vector2.new(1, 0),
		pos = UDim2.new(1, 0, 0, 0),
		ChoiceSection {
			choices = choices :: never,
			mycharacter = mae,
		},
	}
end

return function(target)
	return mount(story, target)
end
