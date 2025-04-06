export type create_client<T...> = {
	iter: () -> () -> (number, T...),
}
export type create_server<T...> = {
	iter: () -> () -> (number, Player, T...),
}

local function create_client<T...>(remote: RemoteEvent)
	local queue = {}
	local connection = remote.OnClientEvent:Connect(function(...: any)
		table.insert(queue, { ... })
	end)

	-- warn(`SETUP ONCLIENTEVENT CONNECTION {connection} for {remote.Name}`)

	return {
		iter = function(): () -> (number, T...)
			local index = 0
			return function(): (number, T...)
				index += 1
				local last_args = table.remove(queue)
				if last_args ~= nil then
					return index, unpack(last_args)
				end

				return
			end
		end,
	}
end

local function create_server<T...>(remote: RemoteEvent)
	local queue = {} :: any
	local connection = remote.OnServerEvent:Connect(function(player, ...: any)
		table.insert(queue, { player, ... })
	end)

	return {
		iter = function(): () -> (number, Player, T...)
			local index = 0
			return function(): (number, Player, T...)
				index += 1
				local last_args = table.remove(queue)
				if last_args ~= nil then
					return index, unpack(last_args)
				end

				return
			end
		end,
	}
end

return {
	create_client = create_client,
	create_server = create_server,
}
