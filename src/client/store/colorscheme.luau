--[[

  This is our base colorscheme we should look to use for our project.
  The main reason is because we want the shades of our accent colours to be consistent
]]
-- stylua: ignore start
local blood_red        = Color3.fromHex("F01700")
local dull_red         = Color3.fromHex("CB1300")

local pure_black       = Color3.fromHex("000000")
local matte_black      = Color3.fromHex("28282B")
local davys_grey_black = Color3.fromHex("555555")

local pure_white       = Color3.fromHex("FFFFFF")
local warm_white       = Color3.fromHex("FDF7EC")
local cool_white       = Color3.fromHex("F0F5FF")

return {
	-- red variants
  blood_red        = blood_red,
  dull_red         = dull_red,

	-- black variants
	-- https://www.color-meanings.com/shades-of-black-color-names-html-hex-rgb-codes/
  pure_black       = pure_black,
  matte_black      = matte_black,
  davys_grey_black = davys_grey_black,

  -- These were created via chatgpt, we could look to do more research on them tbh
  -- They look decent enough though
  pure_white       = pure_white;
  warm_white       = warm_white;
  cool_white       = cool_white;
}
-- stylua: ignore end
