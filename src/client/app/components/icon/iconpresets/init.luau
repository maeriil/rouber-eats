local icon = require(script.Parent.icon)
local presets = {} :: { [string]: icon.icontype }

for i, v in script:GetChildren() do
	if v:IsA("ModuleScript") then
		local stuff = require(v)
		local name = v.Name

		presets[name] = stuff :: icon.icontype
	end
end

return presets
