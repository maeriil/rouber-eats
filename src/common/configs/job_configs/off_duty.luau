local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local create_team = require(ReplicatedStorage.common.utility.create_team)
local jecs = require(ReplicatedStorage.pkg.jecs)
local jobtype = require(script.Parent.jobtype)
local world = require(ReplicatedStorage.common.ecs.world)

type JobType = jobtype.JobType

local pair = jecs.pair
local color = BrickColor.White()
local name = "Off Duty"

local off_duty_job: JobType = {
	name = name,
	color = color,
	team = create_team(color, name),
	max_players = math.huge,
	component = components.OffDuty,
	count_query = world
		:query(components.Client)
		:with(pair(components.Job, components.OffDuty))
		:cached(),
}

return off_duty_job
