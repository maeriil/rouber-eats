local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local food_list = require(ReplicatedStorage.common.configs.food)
local gamedata = require(ServerScriptService.server.store.gamedata)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local t = require(ReplicatedStorage.types)

local c = require(ReplicatedStorage.common.ecs.components)
local p = require(ReplicatedStorage.common.ecs.pairs)
local planck = require(ReplicatedStorage.pkg.planck)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local function system()
	for _, food in food_list do
		local food_id = food.id

		world:add(food_id, c.Food)
		world:set(food_id, c.Value, food.base_value)
		world:set(food_id, c.Name, food.display_name)

		-- SO we can quickly do lookups about details if needed
		gamedata.food_map[food_id] = food
	end

	table.clear(food_list)
	food_list = nil :: never
end

return {
	name = script.Name,
	system = system,
	phase = phases.Server.ServerInitialize.DataSetup,
	runConditions = {
		planck.runOnce(),
	},
}
