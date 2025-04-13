local ReplicatedStorage = game:GetService("ReplicatedStorage")

local StrikePoseTitle = require(ReplicatedStorage.client.app.pages.PosesScreen.StrikePoseTitle)
local vide = require(ReplicatedStorage.pkg.vide)

local function story()
	return {
		StrikePoseTitle {},
	}
end

return function(target)
	return vide.mount(story, target)
end
