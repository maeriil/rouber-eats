local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

type can<T> = T | () -> T
local create = vide.create

type props = {}

local function flexfill(props: props)
	return create "UIFlexItem" {
		FlexMode = Enum.UIFlexMode.Fill,
		-- ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	}
end

return flexfill
