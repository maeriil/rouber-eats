local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserChoices = require(script.Parent.UserChoices)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount
local source = vide.source

local function story()
	local choices = source({
		{ id = 1, text = "Grab a glass of water" },
		{ id = 2, text = "Order a pizza" },
		{ id = 3, text = "Look for something else" },
	})

	return UserChoices {
		choices = choices,
	}
end

return function(target)
	return mount(story, target)
end
