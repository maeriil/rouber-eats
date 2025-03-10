local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local jobtype = require(script.jobtype)
local world = require(ReplicatedStorage.common.ecs.world)

local types = require(ReplicatedStorage.types)
type Entity = types.Entity

type JobType = jobtype.JobType
local jobs_map: { [Entity]: jobtype.JobType } = {}

for i, module in script:GetChildren() do
	local ok, value = pcall(require, module)
	assert(ok, `Module must require correctly`)

	if value == 0 or typeof(value) ~= "table" then
		continue
	end

	local job_details = value :: JobType
	local job_component = job_details.component
	world:add(job_component, job_component)
	world:add(job_component, components.Job)
	jobs_map[job_component] = job_details
end

return jobs_map
