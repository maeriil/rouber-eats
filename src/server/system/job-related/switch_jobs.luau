local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
-- local events = require(ReplicatedStorage.common.events)
local jecs = require(ReplicatedStorage.pkg.jecs)
local job_configs = require(ReplicatedStorage.common.configs.job_configs)
local last_fired = require(ReplicatedStorage.common.utility.last_fired)
local phases = require(ReplicatedStorage.common.ecs.phases)
local ref = require(ReplicatedStorage.common.ecs.ref)
local world = require(ReplicatedStorage.common.ecs.world)

local pair = jecs.pair

local can_request, update_timestamp = last_fired(1) -- Can request 1 event per second
local function end_event(player: Player)
	update_timestamp(player)
end

local failures = {
	[1] = "Attempted to switch to an invalid job",
	[2] = "The requested job does not have enough empty slots",
	[3] = "You do not meet enough requirements to claim the specified job",
}
local function end_with_failure(player: Player, kind: number)
	-- Fire a remote event that does failure related
	if kind == 2 then
		-- Fire a specific remote event
	elseif kind == 3 then
		-- Fire a specific remote event
	end

	warn(`Error: {failures[kind]}`)

	end_event(player)
end

-- local function event_handle(player: Player, job: jecs.Entity<unknown>)
-- 	local e = ref(player)
-- 	local details = job_configs[job]

-- 	if not world:contains(job) or not world:has(job, c.Job) or details == nil then
-- 		return end_with_failure(player, 1)
-- 	end

-- 	if not world:has(e, pair(c.OwnerOf, job)) then
-- 		return end_with_failure(player, 3)
-- 	end

-- 	local count = 0
-- 	for _ in details.count_query:iter() do
-- 		count += 1
-- 	end

-- 	if count >= details.max_players then
-- 		return end_with_failure(player, 2)
-- 	end

-- 	world:add(e, pair(c.Assign, job))
-- 	return end_event(player)
-- end

-- local SwitchJobEvent = events.IWantToSwitchJobs
local function system()
	-- for i, player, job in SwitchJobEvent:query():server():iter() do
	-- 	if not can_request(player) then
	-- 		continue
	-- 	end

	-- 	event_handle(player, job)
	-- end
end

return {
	system = system,
	runConditions = {},
	name = script.Name,
	phase = phases.Update,
}
