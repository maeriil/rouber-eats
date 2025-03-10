local ReplicatedStorage = game:GetService("ReplicatedStorage")
local dialogue_choices = require(script.Parent.dialogue_choices)
local dialogue_frame = require(script.Parent.dialogue_frame)
local dialogue_start = require(script.Parent.dialogue_start)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local jecs = require(ReplicatedStorage.pkg.jecs)
local padding = require(ReplicatedStorage.client.app.components.padding)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity
type Source<T> = vide.Source<T>

local px = use_px.px
local mount = vide.mount
local source = vide.source
local action = vide.action

local function story()
	local animate = source(false)
	use_px.use_px()
	local choices = source({
		{ id = 1 :: any, text = "Open" },
		{ id = 2 :: any, text = "Close" },
		{
			id = 3 :: any,
			text = "Hehe, this is some long action that is kinda long, but i think this is around the maximum length?",
		},
	})

	return frame {
		size = UDim2.new(1, 0, 1, 0),
		padding {
			padding = function()
				return UDim.new(0, px(32))
			end,
		},

		dialogue_frame {
			author = function()
				return "maeriil"
			end,
			response = function()
				return "This is a sample description of what a dialogue might look like"
			end,
		},
		dialogue_choices {
			list = choices,
			pass = function(id)
				print(`the {id} was clicked..`)
			end,
		},
		dialogue_start {
			pass = function()
				print("hiiiiii")
			end,
		},

		action(function(a0: Instance)
			animate(true)
		end),
	}
end

return function(target)
	return mount(story, target)
end
