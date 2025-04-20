local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle = require(ReplicatedStorage.common.utility.remote_util)
local types = require(ReplicatedStorage.types)

local remotes = ReplicatedStorage.common.events.remotes
local remote = remotes.teleport

--[[
  We can make this wayyyy less verbose once Luau releases the RFC
  Explicit type parameter instantiation

  ```lua
  local function f<T>()
    return function(a: T)
      return a
    end
  end
  local a = f<<number>>()
```

  Until then, we need to manually specifiy the type for to_client, from_server...
  which kinda sucks

  How to make it less yucky when it releases? We can just define a function that will
    return to_client, from_server functions directly. It will grab the type at runtime
    and then return to_client, which will take (...) -> void, and another return which
    will return from_server () -> {Iterable<...>}

]]

local function to_client(
	player: Player,
	status: {
		success: boolean,
		error_msg: string,
	},
	building_id: types.Entity?,
	going_interior: boolean?
)
	remote:FireClient(player, status, building_id, going_interior)
end

local function from_server()
	return event_handle.create_client(remotes.teleport) :: event_handle.create_client<
		{ success: boolean, error_msg: string },
		types.Entity,
		boolean
	>
end

local function to_server(building_id: types.Entity, going_interior: boolean)
	remote:FireServer(building_id, going_interior)
end

local function from_client()
	return event_handle.create_server(remotes.teleport) :: event_handle.create_server<
			types.Entity?,
			boolean?
		>
end

return {
	to_client = to_client,
	to_server = to_server,
	from_client = from_client,
	from_server = from_server,
}
