local RunService = game:GetService("RunService")

local function throw_error(error_msg: string, level: number?): never
	if level == 1 then
		error_msg = error_msg .. " This is a bug, please file an issue in the discord server."
	elseif level == 2 then
		error_msg = error_msg
			.. " Reached a supposedly unreachable code. This is a serious issue, please file an issue in the discord server."
	elseif level == 3 then
		error_msg = error_msg .. " This feature has not been created yet!"
	end

	if RunService:IsStudio() or _G.__DEV__ then
		task.spawn(error, error_msg, 2)
	else
		task.spawn(warn, error_msg)
	end

	return 0 :: never
end

return throw_error
