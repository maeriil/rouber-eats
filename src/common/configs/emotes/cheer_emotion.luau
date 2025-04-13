-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animations        = require(ReplicatedStorage.assets.animations)
local config_types      = require(ReplicatedStorage.types.config_types)
-- stylua: ignore end

local animation = Instance.new("Animation")
animation.AnimationId = animations.Cheering1

local cheer_emotion: config_types.rouber_emotion_config_t = {
	name = "cheer_emotion",
	display_image = "//TODO: does not exist yet",
	display_name = "Cheer!",
	animation = animation,
}

return cheer_emotion
