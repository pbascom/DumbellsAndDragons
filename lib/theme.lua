local data = require "lib.data"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local raleway, unifraktur, raleway_bold = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf", "assets/font/Raleway 700.ttf"

local theme = {

	-- Display Settings
	fullWidth = 480,
	fullHeight = 640,

	-- Colors
	green = { 24/255, 234/255, 63/255 },
	darkGreen = { 16/255, 171/255, 23/255 },
	yellow = { 226/255, 216/225, 30/255 },
	darkYellow = { 187/255, 191/255, 64/255 },
	white = 0.94,
	darkWhite = 0.82,
	
	baseFontFamily = raleway,
	boldFontFamily = raleway_bold,
	

	-- Prompt UI Theming
	promptBoxPadding = 14,
	promptBoxHeight = yn*3/6,
	promptBoxColor = { 0.3, 0.5 },

	promptFontSize = 36,
	promptNumberSize = 42,
	promptTextPadding = 14,
	promptTextVerticalDisplacement = 84,

	promptBoxVerticalPadding = 24,

	flavorFontSize = 18,
	flavorVerticalDisplacement = 30,


	buttonRadius = 32.5,
	buttonFontSize = 24,
	buttonFontFamily = raleway,

	buttonVerticalPadding = 48,

	-- Shadows
	shadow = {
		x = {
			medium = 2
		},
		y = {
			medium = 2
		},
		size = {
			medium = 12
		},
		opacity = {
			medium = 0.5,
			dark = 0.8
		}
	}
}

return theme