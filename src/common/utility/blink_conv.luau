local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)

local function as_entity(id: number)
	return (id :: never) :: types.Entity
end

local function as_id<T>(id: number)
	return (id :: never) :: types.Id<T>
end

local function from_entity(id: types.Entity | types.Id)
	return (id :: never) :: number
end

return {
	as_entity = as_entity,
	from_entity = from_entity,
	as_id = as_id,
}
