local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local clientevents = require(ReplicatedStorage.common.clientevents)
local jecs = require(ReplicatedStorage.pkg.jecs)

local phases = require(ReplicatedStorage.common.ecs.phases)
local __ = jecs.Wildcard

local request_setup_map = clientevents.PlayerEvents.setup_map_on_join
local response_setup_map = clientevents.PlayerEvents.i_have_setup_map
local function system()
	for _ in request_setup_map.iter() do
		task.spawn(function()
			local me = Players.LocalPlayer
			local playergui = me.PlayerGui

			local map = playergui.MAP:WaitForChild("map") :: Folder
			map.Parent = workspace
			response_setup_map.fire()
		end)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Client.GeneralSetups.Setup,
	runConditions = {},
}
