local ReplicatedStorage = game:GetService("ReplicatedStorage")
local vide = require(ReplicatedStorage.pkg.vide)
local function my_profile_page()
	return vide.create "Frame" {}
end

return my_profile_page
