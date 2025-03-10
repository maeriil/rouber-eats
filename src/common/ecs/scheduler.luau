local ReplicatedStorage = game:GetService("ReplicatedStorage")
local planck = require(ReplicatedStorage.pkg.planck)
local planckjabby = require(ReplicatedStorage.pkg.planckjabby)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local world = require(script.Parent.world)

local jabby_plugin = planckjabby.new()
local runservice_plugin = planckrunservice.Plugin.new()

local scheduler =
	planck.Scheduler.new(world):addPlugin(jabby_plugin :: never):addPlugin(runservice_plugin :: never)

return scheduler
