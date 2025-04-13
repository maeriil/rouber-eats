local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SpeechBubbleExpanded = require(script.SpeechBubbleExpanded)
local billboard = require(ReplicatedStorage.client.app.components.billboard)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local types = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)
local vide = require(ReplicatedStorage.pkg.vide)

local derive = vide.derive
local show = vide.show

type props = {
	details: types.Source<types.DialogueProximityDetails>,
}

local function DialogueProximity(props: props)
	local details = derive(props.details)
	local adornee = function()
		return details().adornee
	end
	local proximity_type_display = function()
		return details().dialogue_id == uistore.ActiveDialogueProximity()
	end

	return billboard {
		max_distance = 25,
		offset = vector.create(0, 5, 0),
		adornee = adornee,
		SpeechBubbleExpanded {
			text = function()
				return details().proximity_text
			end,
			click = function()
				-- We should actually dispatch the active dialgoue proximity to dialogue started
				-- eventqueue.dispatch_proximity_clicked(uistore.ActiveProximity())
				eventqueue.add_dialogue_started(uistore.ActiveDialogueProximity() :: types.Entity)
			end,
		},
	}
end

return DialogueProximity
