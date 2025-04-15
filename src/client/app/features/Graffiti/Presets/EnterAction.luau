local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DoubleStrokeLetter =
	require(ReplicatedStorage.client.app.features.Graffiti.DoubleStrokeLetter)
local hlayout = require(ReplicatedStorage.client.app.components.layouts.hlayout)
local padding_types = require(ReplicatedStorage.client.app.components.padding.padding_types)
local pane = require(ReplicatedStorage.client.app.components.pane.pane)
local types = require(ReplicatedStorage.types)

type props = {
	rotation: types.Can<number>?,
}

--[[
	TODO: See the comment below. Basically, it looks nice, but this is a localization nightmare
	I like the graffiti style, and we can still do it, just not how we are doing it like below
	We should create some kind of function or something which will output it better. Because if we
	try to translate Enter to some other lang, it would look terrible

	We also want to ideally NOT do X offsets. ONLY Y. We should also "space" the frame so that
	it is as close to the letter as possible. If they have weird "gaps", then let it be, we shouldn't try
	and force them to be close to each other as thats hardcoding..
]]

local function EnterAction(props: props)
	local actiontext = "Enter!"

	--//TODO: DO NOT DO THIS. This is a Localization Nightmare!!!
	local offset_table = { 0.0, 0.1, 0.2, 0.28, 0.35, 0.62 }
	local scale_x_table = { 0.17, 0.13, 0.12, 0.12, 0.145, 0.13 }
	local scale_y_table = { 1, 0.9, 0.85, 0.88, 0.93, 1.24 }
	local rotation_table = { 0, -1, 3, 1, 0, -4 }

	local letters = {}

	for i = 1, 6 do
		local current_letter = actiontext:sub(i, i)
		local scale_x_sz = scale_x_table[i]
		local scale_y_sz = scale_y_table[i]
		local rotation = rotation_table[i]
		local letter_offset = offset_table[i]

		table.insert(
			letters,
			DoubleStrokeLetter {
				letter = current_letter,
				order = i,
				size = UDim2.new(scale_x_sz, 0, scale_y_sz, 0),
				rotation = rotation,
				position = UDim2.new(0.5 - letter_offset, 0, 0.5, 0),
				inverted = not (i == 1 or i == 4),
			}
		)
	end

	return pane {
		size = UDim2.new(1, 0, 1, 0),
		rotation = props.rotation,
		hlayout {
			pad = padding_types.nopad,
		},
		letters,
	}
end

return EnterAction
