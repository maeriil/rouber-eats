local ReplicatedStorage = game:GetService("ReplicatedStorage")
local phone_header = require(ReplicatedStorage.client.app.features.Phone.presets.phone_header)
local portrait = require(script.Parent.portrait)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local mount = vide.mount

local function story()
	use_px.use_px()
	return portrait {
		header = phone_header,
		footer = function() end,
		exit = function() end,
	}
end

return function(target)
	return mount(story, target)
end
