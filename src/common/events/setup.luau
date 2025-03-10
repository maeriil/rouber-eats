local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = require(script.Parent)
local yetanothernet = require(ReplicatedStorage.pkg.yetanothernet)

local before_event, after_event = yetanothernet.createHook(events)

return {
	before_event = before_event,
	after_event = after_event,
}
