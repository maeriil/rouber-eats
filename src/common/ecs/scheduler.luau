local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local phases = require(script.Parent.phases)
local planck = require(ReplicatedStorage.pkg.planck)
local planckjabby = require(ReplicatedStorage.pkg.planckjabby)
local world = require(script.Parent.world)

local jabby_plugin = planckjabby.new()
local scheduler: planck.Scheduler<...any>

local server = phases.Server._pipelines
local client = phases.Client._pipelines

if RunService:IsServer() then
	scheduler = planck.Scheduler
		.new(world)
		:addPlugin(jabby_plugin :: never)
		:insert(phases.NetStart, RunService, "Heartbeat")
		:insertAfter(phases.First, phases.NetStart)
		:insertAfter(server.ServerInitializePipeline, phases.NetStart)
		:insertAfter(server.PlayerAddedRemoved, server.ServerInitializePipeline)
		:insertAfter(server.HousingPipeline, server.PlayerAddedRemoved)
		:insertAfter(phases.PreUpdate, server.HousingPipeline)
		:insertAfter(phases.Update, phases.PreUpdate)
		:insertAfter(phases.PostUpdate, phases.Update)
		:insertAfter(phases.Last, phases.PostUpdate)
		:insertAfter(phases.NetEnd, phases.Last)

	--[[
			!!! VERIFY that the order is correct
		status = ???
		]]
elseif RunService:IsClient() then
	scheduler = planck.Scheduler
		.new(world)
		:addPlugin(jabby_plugin :: never)
		:insert(phases.NetStart, RunService, "Heartbeat")
		:insertAfter(phases.First, phases.NetStart)
		:insertAfter(client.GeneralSetupsPipeline, phases.NetStart)
		:insertAfter(phases.PreUpdate, client.GeneralSetupsPipeline)
		:insertAfter(phases.Update, phases.PreUpdate)
		:insertAfter(phases.PostUpdate, phases.Update)
		:insertAfter(phases.Last, phases.PostUpdate)
		:insertAfter(phases.NetEnd, phases.Last)
else
	error(`Running scheduler in an unknown environment...`)
end

-- local scheduler = planck
-- 	.Scheduler
-- 	.new(world)
-- 	:addPlugin(jabby_plugin :: never)
-- 	:addPlugin(runservice_plugin :: never)
-- 	:insert(client_pipelines.SteppedPipeline, RunService, "Stepped")
-- 	:insert(server_pipelines.ServerInitializePipeline, RunService, "Heartbeat")
-- 	:insert(server_pipelines.PlayerAddedRemovedPipeline, RunService, "Heartbeat")
-- 	:insert(server_pipelines.HousingPipeline, RunService, "Heartbeat")
-- 	-- :insert(client_pipelines.ServerResponsePipeline)
-- 	:insert(
-- 		client_pipelines.ServerResponsePipeline,
-- 		RunService,
-- 		"Heartbeat"
-- 	)

-- end

return scheduler
