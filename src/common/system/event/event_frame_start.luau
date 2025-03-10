local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = require(ReplicatedStorage.common.events.setup)
local planckrunservice = require(ReplicatedStorage.pkg.planckrunservice)

local function sys()
	events.before_event()
end

return {
	name = script.Name,
	system = sys,
	phase = planckrunservice.Phases.First,
	runConditions = {},
}
