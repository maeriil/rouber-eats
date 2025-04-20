-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local result_lines      = require(ReplicatedStorage.client.app.features.Result.result_lines)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)

local mount             = vide.mount
local px                = use_px.px
local source            = vide.source
-- stylua: ignore end

local function story()
	local animate = source(false)
	use_px.use_px()

	task.spawn(function()
		animate(true)
	end)

	return result_lines {
		animate = animate,
	}
end

return function(target)
	return mount(story, target)
end
