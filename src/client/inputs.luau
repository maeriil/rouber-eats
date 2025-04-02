local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local eventqueue = require(ReplicatedStorage.client.app.uistore.eventqueue)
local last_fired = require(ReplicatedStorage.common.utility.last_fired)
local uistore = require(ReplicatedStorage.client.app.uistore)

--[[
  TODO: This file might be better off being used in ECS?
  Or we can also have a map containing keybinds and directly check it from there tbh?

]]

local can_fire, update_last_fired = last_fired(0.5)
UserInputService.InputBegan:Connect(function(obj: InputObject, gpe: boolean)
	local proximity_key = Enum.KeyCode.E
	local player = Players.LocalPlayer

	if gpe then
		return
	end

	local active_proximity = uistore.ActiveProximity()
	if obj.KeyCode == proximity_key and active_proximity ~= nil and can_fire(player) then
		-- We found some proximity, which means we should dispatch details to eventqueue
		eventqueue.dispatch_proximity_clicked(active_proximity)
		update_last_fired(player)
	end
end)

UserInputService.InputChanged:Connect(function(a0: InputObject, a1: boolean) end)
UserInputService.InputEnded:Connect(function(a0: InputObject, a1: boolean) end)

return 0
