local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChoiceBubble = require(script.Parent.ChoiceBubble)
local DialogueAvatar = require(script.Parent.DialogueAvatar)
local ResponseDialogue = require(script.Parent.ResponseDialogue)
local SpeechBubble = require(script.Parent.SpeechBubble)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local source = vide.source

local noob = workspace:FindFirstChild("Noob")

local function DialogueTest()
	local play_text = source(true)

	return frame {
		size = UDim2.fromScale(1, 1),
		vlayout {},
		SpeechBubble {
			click = function()
				print("Clicked on bubble!")
			end,
			text = "The longest amount of text I can fit in the bubble. It still overflows a bit",
		},
		SpeechBubble {
			click = function()
				print("Clicked on bubble!")
			end,
			text = "A small message in bubble",
		},
		ResponseDialogue {
			click = function()
				print("clicking!!")
				play_text(true)
			end,
			text = "The longest amount of text I can fit on the bubble. Notice how compared to all other, we can fit the most on this.This makes sense as they are meant to hold a lot more text",
			animate = play_text,
			author = "longestusername",
		},

		DialogueAvatar {
			model = noob,
		},

		ChoiceBubble {
			click = function()
				print("Selected the dialogue")
			end,
			text = "Maximum amount of characters we can fit for the User Dialogue",
			inverted = false,
		},
	}
end

return function(target)
	return vide.mount(DialogueTest, target)
end
