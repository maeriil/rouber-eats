local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChoiceBubble = require(script.Parent.ChoiceBubble)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local flexfill = require(ReplicatedStorage.client.app.components.flex.flexfill)
local frame = require(ReplicatedStorage.client.app.components.pane.frame)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local values = vide.values
local px = use_px.px

type props = {
	choices: types.Source<{ types.DialogueType }>,
	order: types.Can<number>,
}

local function UserChoices(props: props)
	return pane {
		size = function()
			return UDim2.new(1, 0, 1, 0)
		end,
		flexfill {},
		vlayout {
			pad = padding_types.nopad,
		},

		values(props.choices, function(dialogue: types.DialogueType, order: () -> number)
			local n = order()
			local tweak_num = 3
			return pane {
				order = n,
				size = function()
					return UDim2.new(1, 0, 0, px(75))
				end,
				ChoiceBubble {
					click = function()
						eventqueue.add_dialogue_event_choice(dialogue.id)
					end,
					inverted = not (n % tweak_num == 0),
					order = n,
					text = dialogue.text,
					rotation = function()
						local res = n % tweak_num

						return if res == 0 then 3 elseif res == 1 then 0 elseif res == 2 then -3 else 0
					end,
				},
			}
		end),
	}
end

return UserChoices
