local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local vide = require(ReplicatedStorage.pkg.vide)

local show = vide.show
local source = vide.source
local effect = vide.effect
local cleanup = vide.cleanup

local DEFAULT_SECONDS = 5

type props = {
	[any]: any,
}

local function timeout(t: number, callback: () -> ()): () -> ()
	local cn

	local function stop()
		if cn then
			cn:Disconnect()
			cn = nil
		end
	end

	cn = RunService.Heartbeat:connect(function(dt)
		t -= dt
		if t <= 0 then
			callback()
			stop()
		end
	end)

	cleanup(cn)
end

return function(component: (any?, any?) -> any, src: () -> boolean, second: number?)
	return function(props: props, ...)
		local others = ...
		local initialProps = if typeof(props) == "table" then props else {}
		initialProps.open = src

		local showIt = source(src())

		effect(function()
			if src() then
				showIt(true)
			else
				timeout(second or DEFAULT_SECONDS, function()
					showIt(false)
				end)
			end
		end)

		return show(showIt, function()
			return component(initialProps, others)
		end)
	end
end
