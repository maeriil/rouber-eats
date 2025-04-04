local ReplicatedStorage = game:GetService("ReplicatedStorage")
local types = require(ReplicatedStorage.types)
local store_list = {}

--[[
  When game starts, we want to require this once, it will ensure every module is initialized
  Then when the server fires the event to map the Entity -> Config type, we will use this table
  to perform the lookup. Once the event is processed, we will clear this table and mark it as nil
  as we would no longer need to do the Name -> Content lookup but rather Entity -> Content lookup

  When server sends, it should send content.string_id as that contents the script's name
]]

for _, module in script:GetChildren() do
	local name = module.Name
	local _, _content = pcall(require, module)
	local content = _content :: types.StoreConfigType

	store_list[name] = content
end

return store_list
