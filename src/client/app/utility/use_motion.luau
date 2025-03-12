local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ripple = require(ReplicatedStorage.pkg.ripple)
local vide = require(ReplicatedStorage.pkg.vide)

local cleanup = vide.cleanup
local source = vide.source

local function useMotion<T>(initialValue: T)
	local state = source(initialValue)
	local motion = ripple.createMotion(initialValue)

	cleanup(motion)
	cleanup(RunService.Heartbeat:Connect(function(dt)
		state(motion:step(dt))
	end))

	return state, motion
end

return useMotion
