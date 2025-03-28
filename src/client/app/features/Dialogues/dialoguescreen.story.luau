local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueScreenPanel = require(script.Parent.DialogueScreenPanel)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount

local function story()
	return DialogueScreenPanel {}
end

return function(target)
	return mount(story, target)
end
