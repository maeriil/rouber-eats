local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local job_configs = require(ReplicatedStorage.common.configs.job_configs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair
local __ = jecs.Wildcard

local function assign_job()
	for e, player, job in world:query(c.Client, pair(c.Job, c.Assign)):iter() do
		world:remove(e, pair(c.Job, c.Assign))

		local previous_job = world:target(e, c.Job)
		if previous_job ~= nil then
			world:remove(e, pair(c.Job, previous_job))
		end

		local job_details = job_configs[job]

		world:add(e, pair(c.Job, job))
		player.Team = job_details.team
	end
end

local without_jobs = world:query(c.Client):without(pair(c.Job, __)):cached()
local function system() -- Query for all new players who wont have any jobs
	for e, player in without_jobs:iter() do
		-- Set them as OffDuty initially, then on client side, similar to PizzaPlace, we will
		-- show them the possible occupations they can do? idk
		world:set(e, pair(c.Job, c.Assign), c.OffDuty)
	end

	assign_job()
end

return {
	runConditions = {},
	phase = phases.Update,
	system = system,
	name = script.Name,
}
