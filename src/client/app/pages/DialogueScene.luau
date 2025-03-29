local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DialogueScreenPanel =
	require(ReplicatedStorage.client.app.features.Dialogues.DialogueScreenPanel)

type props = {}

local function DialogueScene(props: props)
	return DialogueScreenPanel {}
end

return DialogueScene
