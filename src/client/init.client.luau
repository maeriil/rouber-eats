local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

do
	-- update debug related stuff here
	_G.__JECS_DEBUG = false
	-- _G.__JECS_HI_COMPONENT_ID = 256 -- Change later
	workspace:SetAttribute("GizmosEnabled", RunService:IsStudio())

	-- Here are the modules that needs to be required at least once before we startup
	-- our system. Modules get cached so we can access them in system after as normal
	require(ReplicatedStorage.common.configs.food)
	require(ReplicatedStorage.common.configs.restaurant)
	require(ReplicatedStorage.common.configs.store)
	require(ReplicatedStorage.common.configs.items)

	require(ReplicatedStorage.common.configs.buildings.buildings_map)
	require(ReplicatedStorage.common.configs.job_configs)
	require(ReplicatedStorage.common.store.buildings)
	require(script.inputs)
end

local startup = require(ReplicatedStorage.common.ecs.startup)
startup({
	script.system,
	ReplicatedStorage.common.system,
})

local app = require(script.app)
local vide = require(script.app.vide_setup)
local player = Players.LocalPlayer
local gui = player.PlayerGui
vide.mount(app, gui)
