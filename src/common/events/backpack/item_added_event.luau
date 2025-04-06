local ReplicatedStorage = game:GetService("ReplicatedStorage")
local event_handle = require(ReplicatedStorage.common.utility.remote_util)
local types = require(ReplicatedStorage.types)

local remotes = ReplicatedStorage.common.events.remotes
local remote = remotes.item_added

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
	item_id: { types.Entity },
	count: { number },
	is_new: { boolean }
)
	remote:FireClient(player, item_id, count, is_new)
end

local function from_server()
	return event_handle.create_client(
			remote
		) :: event_handle.create_client<{ types.Entity }, { number }, { boolean }>
end

return {
	to_client = to_client,
	from_server = from_server,
}
