local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local function translate_number_async(n: number)
	--[[
    TODO: work on this once we have setup localization tables and etc
  ]]
	-- local player = Players.LocalPlayer
	-- local translator = LocalizationService:GetTranslatorForPlayerAsync(player)
	-- local out_string = translator:FormatByKey("yourgame.foo.bar", {
	-- 	Number = n,
	-- })

	-- return out_string
	-- this is a random luau code i copied from stack overflow, that we can use for now
	-- https://stackoverflow.com/questions/10989788/format-integer-in-lua

	local i, j, minus, int, fraction = tostring(n):find("([-]?)(%d+)([.]?%d*)")

	-- reverse the int-string and append a comma to all blocks of 3 digits
	int = int:reverse():gsub("(%d%d%d)", "%1,")

	-- reverse the int-string back remove an optional comma and put the
	-- optional minus and fractional part back
	return minus .. int:reverse():gsub("^,", "") .. fraction
end

return translate_number_async
