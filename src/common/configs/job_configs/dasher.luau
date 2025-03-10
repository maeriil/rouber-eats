local ReplicatedStorage = game:GetService("ReplicatedStorage")
local components = require(ReplicatedStorage.common.ecs.components)
local create_team = require(ReplicatedStorage.common.utility.create_team)
local jecs = require(ReplicatedStorage.pkg.jecs)
local jobtype = require(script.Parent.jobtype)
local world = require(ReplicatedStorage.common.ecs.world)

type JobType = jobtype.JobType

local color = BrickColor.Blue()
local name = "Dasher"
local pair = jecs.pair

local dasher_job: JobType = {
	name = name,
	color = color,
	team = create_team(color, name),
	max_players = 1,
	component = components.Dasher,
	count_query = world
		:query(components.Client)
		:with(pair(components.Job, components.Dasher))
		:cached(),
}

return dasher_job
