local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Result = require(ReplicatedStorage.client.app.features.Result)
local result_sources = require(ReplicatedStorage.client.app.features.Result.result_sources)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount

local function story()
	task.delay(1, function()
		result_sources.animate_lines(true)
	end)

	return Result {}
end

return function(target)
	return mount(story, target)
end
