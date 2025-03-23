--[[
  This is the main graffit font the game uses
]]

-- This is the Irish Grover font

-- stylua: ignore start
local GraffitiFont = Font.fromId (
  12187376910,
  Enum.FontWeight.ExtraBold,
  Enum.FontStyle.Italic
)
-- stylua: ignore end

local large = 96
local medium = 64
local small = 32

return {
	font = GraffitiFont,
	sizes = {
		large = large,
		medium = medium,
		small = small,
	},
}
