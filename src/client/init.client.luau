local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

do
	-- update debug related stuff here
	_G.__JECS_DEBUG = true
	-- _G.__JECS_HI_COMPONENT_ID = 256 -- Change later

	-- Here are the modules that needs to be required at least once before we startup
	-- our system. Modules get cached so we can access them in system after as normal
	require(ReplicatedStorage.common.configs.job_configs)
	require(ReplicatedStorage.common.events)
	require(ReplicatedStorage.common.store.buildings)
end

local startup = require(ReplicatedStorage.common.ecs.startup)
startup({
	script.system,
	ReplicatedStorage.common.system,
})

local app = require(script.app)
local ui_store = require(script.app.ui_store)

UserInputService.InputBegan:Connect(function(i: InputObject, a1: boolean)
	if i.KeyCode == Enum.KeyCode.P then
		print("toggling phone")
		ui_store.ShowPhone(not ui_store.ShowPhone())
	end
end)

print(GuiService:GetGuiInset())

local vide = require(script.app.vide_setup)
local player = Players.LocalPlayer
local gui = player.PlayerGui
vide.mount(app, gui)
