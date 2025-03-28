local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local events = require(ReplicatedStorage.common.events.setup)
local phases = require(ReplicatedStorage.common.ecs.phases)

local function sys()
	-- events.after_event()
end

return {
	name = script.Name,
	system = sys,
	phase = phases.NetEnd,
	runConditions = {},
}
