local ReplicatedStorage = game:GetService("ReplicatedStorage")
local config_types = require(ReplicatedStorage.types.config_types)
local types = require(ReplicatedStorage.types)

local emotes = {} :: { [types.rouber_emotion_t]: config_types.rouber_emotion_config_t }

for _, module: ModuleScript in script:GetChildren() do
	local _, _content = pcall(require, module)
	local content = _content :: config_types.rouber_emotion_config_t

	emotes[content.name] = content
end

return emotes
