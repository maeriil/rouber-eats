local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local client_without_humanoid_query = world:query(c.Client, c.Model):without(c.Humanoid):cached()
local function system()
	for i, client, character in client_without_humanoid_query:iter() do
		local humaniod = character:FindFirstChildOfClass("Humanoid")
		if not humaniod then
			continue
		end

		--//TODO
		-- Configure humanoid here, we want to make sure resetting character doesnt trigger
		-- PlayerRemoving

		-- humaniod.BreakJointsOnDeath = false
		-- humaniod.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
		-- humaniod.JumpHeight = 10
		-- humaniod.RequiresNeck = false
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
		-- --//TODO We should disable jumping when we are inside home or any interior building
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Landed, false)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		-- humaniod:SetStateEnabled(Enum.HumanoidStateType.Swimming, true)

		world:set(i, c.Humanoid, humaniod)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
