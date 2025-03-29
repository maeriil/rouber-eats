local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)

local function orders_page()
	return vide.create "Frame" {}
end

return orders_page
