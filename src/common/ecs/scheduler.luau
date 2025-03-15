local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local phases = require(script.Parent.phases)
local planck = require(ReplicatedStorage.pkg.planck)
local planckjabby = require(ReplicatedStorage.pkg.planckjabby)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local world = require(script.Parent.world)

local jabby_plugin = planckjabby.new()
local runservice_plugin = planckrunservice.Plugin.new()

local Pipelines = phases.Pipelines

local scheduler = planck.Scheduler
	.new(world)
	:addPlugin(jabby_plugin :: never)
	:addPlugin(runservice_plugin :: never)
	:insert(Pipelines.SteppedPipeline, RunService, "Stepped")

return scheduler
