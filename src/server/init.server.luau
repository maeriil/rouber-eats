local ReplicatedStorage = game:GetService("ReplicatedStorage")
local startup = require(ReplicatedStorage.common.ecs.startup)

do
	-- update debug related stuff here
	_G.__JECS_DEBUG = false
	-- _G.__JECS_HI_COMPONENT_ID = 256 -- Change late

	-- Here are the modules that needs to be required at least once before we startup
	-- our system. Modules get cached so we can access them in system after as normal

	require(ReplicatedStorage.common.configs.food)
	require(ReplicatedStorage.common.configs.restaurant)
	require(ReplicatedStorage.common.configs.store)
	require(ReplicatedStorage.common.configs.items)
	-- require(ReplicatedStorage.common.configs.restaurant)
	require(ReplicatedStorage.common.configs.buildings.buildings_map)
	require(script.store.playerstore)
	require(script.store.playerdatastore)
	-- require(script.store.serverstore)
	require(script.store.playersetupconfig)
	require(ReplicatedStorage.common.configs.job_configs)
end

startup({
	script.system,
	ReplicatedStorage.common.system,
})
