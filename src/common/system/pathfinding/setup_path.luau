local PathfindingService = game:GetService("PathfindingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)
type Entity = types.Entity

local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard

local SetupPath = pair(c.Start, c.Path)
local create_path = world:query(c.AgentParams, c.PathCosts):with(SetupPath):cached()
local function system()
	for id, params, costs in create_path:iter() do
		local agent_params = {
			AgentRadius = params.radius,
			AgentHeight = params.height,
			AgentCanJump = params.can_jump,
			AgentCanClimb = params.can_climb,
			WaypointSpacing = params.spacing,
			costs = costs,
		}

		local path = PathfindingService:CreatePath(agent_params)
		world:set(id, c.Path, path)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
