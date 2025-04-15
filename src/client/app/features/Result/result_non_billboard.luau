local ReplicatedStorage = game:GetService("ReplicatedStorage")

local result_sources = require(ReplicatedStorage.client.app.features.Result.result_sources)
local result_title = require(ReplicatedStorage.client.app.features.Result.result_title)
local vide = require(ReplicatedStorage.pkg.vide)
local show = vide.show

local function result_non_billboard(props)
	return {
		show(result_sources.start_animation_title, function()
			return result_title {}
		end),
	}
end

return result_non_billboard
