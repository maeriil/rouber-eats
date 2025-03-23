--[[
  Created by @yetanotherclown
  source: https://discord.com/channels/385151591524597761/1323242472712831109/1353115421502472244

  The purpose of this utility function is to print out the order of systems and scheduler
  This helps to identify any ordering issue bugs we might encounter
  Phases inside Pipelines are grouped with (), and Systems of Phases are grouped with []
]]

local function getOrder(scheduler, graph)
	local sorted = graph:getOrderedList()
	local order = ""
	local n = 0

	for _, node in sorted do
		n += 1

		if node._type and node._type == "pipeline" then
			node = `{node} -> ({getOrder(scheduler, node.dependencyGraph)})`
		end

		if node._type and node._type == "phase" and scheduler._phaseToSystems[node] then
			local systems = ""

			for i, system in scheduler._phaseToSystems[node] do
				local systemInfo = scheduler._systemInfo[system]

				if i == 1 then
					systems ..= `{systemInfo.name}`
					continue
				end

				systems ..= ` -> {systemInfo.name}`
			end

			node = `{node} -> [{systems}]`
		end

		if n == 1 then
			order ..= `{node}`
			continue
		end

		order ..= ` -> {node}`
	end

	return order
end

local function printOrder(scheduler: any, runServiceAdded: boolean)
	local orderOfGraphs = {}

	for identifier, graph in scheduler._eventDependencyGraphs do
		orderOfGraphs[identifier] = getOrder(scheduler, graph)
	end

	if not runServiceAdded then
		orderOfGraphs["default"] = getOrder(scheduler, scheduler._defaultDependencyGraph)
	end

	for name, order in orderOfGraphs do
		print(`[{name}]: {order}`)
	end
end

return printOrder
