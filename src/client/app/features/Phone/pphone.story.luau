local ReplicatedStorage = game:GetService("ReplicatedStorage")
local phone = require(script.Parent)
local ui_store = require(ReplicatedStorage.client.app.ui_store)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local px = use_px.px

local function story()
	use_px.use_px()
	ui_store.ShowPhone(true)

	return phone {}
end

return function(target)
	return vide.mount(story, target)
end
