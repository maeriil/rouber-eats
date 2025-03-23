local ReplicatedStorage = game:GetService("ReplicatedStorage")
local gameasset = ReplicatedStorage.gameasset :: Folder
local buildings = gameasset:FindFirstChild("buildings") :: Folder

local buildingsmap = {} :: { [string]: Folder & {
	Exterior: Model,
	Interior: Model,
} }

for i, building in buildings:GetChildren() do
	assert(building:IsA("Folder"), `{building.Name} is not a folder somehow..`)
	assert(
		building:FindFirstChild("Interior"),
		`The building {building.Name} does not have an interior Model`
	)
	assert(
		building:FindFirstChild("Exterior"),
		`The building {building.Name} does not have an interior Model`
	)

	buildingsmap[building.Name] = building :: never
end

return buildingsmap
