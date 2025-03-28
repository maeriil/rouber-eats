local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ChoiceBubble = require(script.Parent.ChoiceBubble)
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)
local use_px = require(ReplicatedStorage.client.app.utility.use_px)
local vide = require(ReplicatedStorage.pkg.vide)
local vlayout = require(ReplicatedStorage.client.app.components.layouts.vlayout)

local values = vide.values
local px = use_px.px
local untrack = vide.untrack

type props = {
	choices: types.Source<{ types.DialogueType }>,
	order: types.Can<number>?,
}

local function calculateRotation(index: number, total: number, maxRotation: number)
	-- chat gpt ahh code
	if total == 1 then
		return maxRotation
	elseif total == 2 then
		return index == 1 and -maxRotation or maxRotation
	else
		-- Calculate using a symmetric distribution around the middle
		local mid = (total + 1) / 2
		return (index - mid) / (mid - 1) * maxRotation
	end
end

local function UserChoices(props: props)
	local choices = untrack(props.choices)
	local total_choices = #choices
	return {
		-- size = function()
		-- 	return UDim2.new(1, 0, 1, 0)
		-- end,
		-- flexfill {},
		vlayout {
			pad = function()
				return UDim.new(0, -px(36))
			end,
		},

		values(props.choices, function(dialogue: types.DialogueType, order: () -> number)
			local n = order()
			local tweak_num = 3
			return pane {
				order = n,
				size = function()
					return UDim2.new(1, 0, 0, px(150))
				end,
				ChoiceBubble {
					click = function()
						eventqueue.add_dialogue_event_choice(dialogue.id)
					end,
					inverted = not (n % tweak_num == 0),
					order = n,
					text = dialogue.text,
					rotation = function()
						return -calculateRotation(n, total_choices, 10)
					end,
				},
			}
		end),
	} :: { unknown }
end

return UserChoices
