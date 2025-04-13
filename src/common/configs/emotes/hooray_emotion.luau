-- stylua: ignore start
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local animations        = require(ReplicatedStorage.assets.animations)
local config_types      = require(ReplicatedStorage.types.config_types)
-- stylua: ignore end

--TODO: honestly we can directly store the animation id here tbh unless we use asphalt

local animation = Instance.new("Animation")
animation.AnimationId = animations.Run

local hooray_emotion: config_types.rouber_emotion_config_t = {
	name = "hooray_emotion",
	display_image = "//TODO: does not exist yet",
	display_name = "Hooray!",
	animation = animation,
}

return hooray_emotion
