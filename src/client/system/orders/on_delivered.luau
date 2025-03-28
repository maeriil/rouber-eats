local ReplicatedStorage = game:GetService("ReplicatedStorage")
local c = require(ReplicatedStorage.common.ecs.components)
local jecs = require(ReplicatedStorage.pkg.jecs)
local phases = require(ReplicatedStorage.common.ecs.phases)
local __ = jecs.Wildcard

local function system()
	-- for _, params in events.CompletedOrderAnimation:query():client():iter() do
	-- 	warn(`Completed the order. Now we should do the animation `)
	-- 	local memodel = params.memodel
	-- 	local person = params.housemodel

	-- 	setup_npc_model(memodel)
	-- 	setup_npc_model(person)
	-- end
end

return {
	name = script.Name,
	system = system,
	phase = phases.Update,
	runConditions = {},
}
