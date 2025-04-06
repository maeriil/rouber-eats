local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local vide = require(ReplicatedStorage.pkg.vide)

local action = vide.action
local cleanup = vide.cleanup

return function(callback: () -> ())
	return action(function(gui_object: Instance)
		assert(gui_object:IsA("GuiObject"), "Must be Gui Object")

		local connection = UserInputService.InputBegan:Connect(function(obj: InputObject, gpe: boolean)
			if
				obj.UserInputType == Enum.UserInputType.MouseButton1
				or obj.UserInputType == Enum.UserInputType.Touch
			then
				-- print("Click found!")
				local x, y = obj.Position.X, obj.Position.Y
				local size = gui_object.AbsoluteSize
				local pos = gui_object.AbsolutePosition

				local is_inside_ui = (x >= pos.X and x <= pos.X + size.X)
					and (y >= pos.Y and y <= pos.Y + size.Y)

				-- print("We are clicking inside UI? ", is_inside_ui)

				if not is_inside_ui then
					callback()
				end
			end
		end)

		cleanup(connection)
	end)
end
