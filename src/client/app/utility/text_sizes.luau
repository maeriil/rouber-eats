local HeadingSize = {
	h1 = 64,
	h2 = 48,
	h3 = 32,
	h4 = 24,
	h5 = 20,
	h6 = 18,
	p = 16,
}

local basefont = Font.fromEnum(Enum.Font.BuilderSans)

-- Setup the fonts and others too?

return {
	heading = HeadingSize,
	font = basefont,
	bolded = function(str: string)
		return `<b>{str}</b>`
	end,
}
