local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local assets = require(ReplicatedStorage.assets)
local jecs = require(ReplicatedStorage.pkg.jecs)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local setup_building_exterior =
	require(ReplicatedStorage.common.configs.buildings.setup_building_exterior)
local t = require(ReplicatedStorage.types)
local uistore = require(ReplicatedStorage.client.app.uistore)

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local events = require(ReplicatedStorage.common.events)
local get_true_ancestor = require(ReplicatedStorage.common.utility.get_true_ancestor)
local tags = require(ReplicatedStorage.types.tags)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local gamemap = workspace.GameMap
local function system()
	for _ in events.SetupMapOnJoin:query():client():iter() do
		task.spawn(function()
			warn(`SETTING UP THE MAP...`)
			local me = Players.LocalPlayer
			local playergui = me.PlayerGui

			local map = playergui.MAP:WaitForChild("Map") :: Folder
			map.Parent = gamemap

			-- For each map, we want to go through the restaurants and set them up in the client
			-- We also want to go through each of the roads / paths and create two different pathfinding costs

			local footpaths_list = map:FindFirstChild("Footpaths") :: Folder?
			local roads_list = map:FindFirstChild("Road") :: Folder?
			local restaurant_list = map:FindFirstChild("Restaurant") :: Folder?

			assert(footpaths_list ~= nil, `There does not exist a folder named Footpaths in Map folder`)
			assert(roads_list ~= nil, `There does not exist a folder named roads in Map folder`)
			assert(
				restaurant_list ~= nil,
				`There does not exist a folder named restaurants in Map folder`
			)

			-- CHECK THIS AFTER
			-- for _, restaurant in restaurant_list:GetChildren() do
			-- 	local exterior_name = restaurant.Name
			-- 	assert(
			-- 		restaurant:IsA("Model"),
			-- 		`Added a non model restaurant with the name {exterior_name} to Restaurant List`
			-- 	)

			-- 	local restaurantid = setup_building_exterior(restaurant)
			-- 	world:add(restaurantid, c.Restaurant)
			-- 	world:set(restaurantid, c.Name, exterior_name)
			-- end

			events.IHaveSetupMapToWorkspace:send()
			warn(`FINISHED SETTING UP THE MAP...`)
		end)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Client.GeneralSetups.Setup,
	runConditions = {},
}
