export type Queue<T...> = typeof(setmetatable(
	{} :: {
		--[=[
        Uses Lua's double queue style, where we keep track of first and last index\
        However this queue only performs push_right operation
    ]=]
		add: (self: Queue<T...>, T...) -> (),

		--[=[
        Clear the entire array portion of the list\
        Uses table.clear internally
    ]=]
		clear: (self: Queue<T...>) -> (),

		--[=[
        Iterate over the queue without draining it\
        This is useful for when we don't want to drain the iterator once we finish using it
    ]=]
		iter: (self: Queue<T...>) -> () -> T...,
	},
	{} :: {
		--[=[
        Grab the size of the array
    ]=]
		__len: (self: Queue<T...>) -> number,

		--[=[
        Iterate over the queue and drain it once we finish\
        This is more subtle so maybe avoid using it
    ]=]
		__iter: (self: Queue<T...>) -> () -> T...,
	}
))

type Array<T> = { T }

local Queue = {}
do
	Queue.__index = Queue

	type _Queue = Queue<...any> & {
		size: number,

		-- We are just reimplementing the official Lua Queue in Luau
		first: number,
		last: number,
		list: Array<any>,
	}

	--[=[
        Queue data structure that only performs push and clear\
        This queue forces you to only have 1 type, you can specifiy it by using Queue<Type>. Example: local myqueue: Queue<number> = Queue.new()\
        Supports iterating over the queue as well by either calling iter() or implicitly\
        NOTE: If pop is needed, we can just file an issue
    ]=]
	function Queue.new<T...>(): Queue<T...>
		local self: _Queue = setmetatable({
			size = 0,
			first = 0,
			last = -1,
			list = {},
		}, Queue) :: any

		return self :: Queue<T...>
	end

	function Queue.add(self: _Queue, ...: unknown)
		assert((...) ~= nil, "First args may not be nil")

		local last = self.last + 1

		self.last = last
		self.size += 1
		self.list[last] = select(1, ...)
	end

	function Queue.clear(self: _Queue)
		self.size = 0
		self.first = 0
		self.last = -1

		table.clear(self.list)
	end

	local function iter(self: _Queue, clear_on_finish: boolean)
		local first = self.first - 1
		local last = self.last
		local list = self.list

		return function()
			first += 1
			if first <= last then
				return list[first]
			end

			if first >= last and clear_on_finish then
				self:clear()
			end

			return nil
		end
	end

	Queue.iter = function(self)
		return iter(self, false)
	end
	Queue.__iter = function(self)
		return iter(self, true)
	end

	function Queue.__len(self: _Queue)
		local size = self.size
		return size
	end
end

return Queue
