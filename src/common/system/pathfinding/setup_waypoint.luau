local ReplicatedStorage = game:GetService("ReplicatedStorage")
local future = require(ReplicatedStorage.pkg.future)
local jecs = require(ReplicatedStorage.pkg.jecs)

type Entity<T = nil> = jecs.Entity<T>
local c = require(ReplicatedStorage.common.ecs.components)
local phases = require(ReplicatedStorage.common.ecs.phases)
local pair = jecs.pair
local world = require(ReplicatedStorage.common.ecs.world)
local __ = jecs.Wildcard
local createfuture = future.Future.new

local StartPos = pair(c.Position, c.Start)
local EndPos = pair(c.Position, c.End)
local SetupWaypoint = pair(c.Start, c.PathWaypoints)
local generate_paths = world:query(StartPos, EndPos, c.Path):with(SetupWaypoint):cached()
local function system()
	for id, start, dest, path in generate_paths:iter() do
		local path_future = createfuture(function(...)
			path:ComputeAsync(start :: never, dest :: never)
			if path.Status == Enum.PathStatus.Success then
				return path:GetWaypoints()
			else
				warn(`Pathfinding service failed with error code {path.Status}. Returning empty table`)
				return {}
			end
		end)

		world:set(id, c.PathFuture, path_future)
		world:remove(id, SetupWaypoint)
	end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
