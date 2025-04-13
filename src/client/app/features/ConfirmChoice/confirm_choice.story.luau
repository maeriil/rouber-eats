-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local frame             = require(ReplicatedStorage.client.app.components.pane.frame)
local ConfirmChoice     = require(ReplicatedStorage.client.app.features.ConfirmChoice)
local use_px            = require(ReplicatedStorage.client.app.utility.use_px)
local vide              = require(ReplicatedStorage.pkg.vide)

local mount             = vide.mount
local px                = use_px.px
-- stylua: ignore end

local function story()
	use_px.use_px()

	return frame {
		color = Color3.fromRGB(0, 200, 200),
		ConfirmChoice {
			on_accept = function()
				print("accept button was clicked")
			end,
			on_reject = function()
				print("reject button was clicked")
			end,
			message = function()
				return `confirm your choice`
			end,
		},
	}
end

return function(target)
	return mount(story, target)
end
