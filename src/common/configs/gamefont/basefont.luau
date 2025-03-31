--[[
  This is the main base font for the game
]]

-- This is the Irish Grover font

-- stylua: ignore start
local BaseFont = Font.fromId (
  12187374954,
  Enum.FontWeight.ExtraBold,
  Enum.FontStyle.Italic
)
-- stylua: ignore end

local large = 96
local medium = 64
local small = 32

return {
	font = BaseFont,
	sizes = {
		large = large,
		medium = medium,
		small = small,
	},
}
