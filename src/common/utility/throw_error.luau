local RunService = game:GetService("RunService")

local function throw_error(error_msg: string)
	if RunService:IsStudio() or _G.__DEV__ then
		task.spawn(error, error_msg)
	else
		task.spawn(warn, error_msg)
	end
end

return throw_error
