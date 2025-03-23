local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sounds = ReplicatedStorage.sound :: Folder
local global = sounds:FindFirstChild("Global") :: Sound
local uisound = sounds:FindFirstChild("UISound") :: Sound

return {
	global = global,
	uisound = uisound,
}
