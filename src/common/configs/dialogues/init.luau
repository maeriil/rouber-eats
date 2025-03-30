local basic_convo_1 = require(script.npc.basic_convo_1)
local condition_test_convo = require(script.npc.condition_test_convo)
local restaurant_general_dialogues = require(script.restaurant.restaurant_general_dialogues)

local npc_dialogues = {
	[basic_convo_1.key] = basic_convo_1.dialogue,
	[condition_test_convo.key] = condition_test_convo.dialogue,
	[restaurant_general_dialogues.key] = restaurant_general_dialogues.dialogue,
}

return npc_dialogues
