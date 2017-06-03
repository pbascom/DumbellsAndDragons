local data = require "lib.data"

local raleway, unifraktur, raleway_bold = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf", "assets/font/Raleway 700.ttf"

local theme = {
	green = { 24/255, 234/255, 63/255 },
	darkGreen = { 16/255, 171/255, 23/255 },
	yellow = { 226/255, 216/225, 30/255 },
	darkYellow = { 187/255, 191/255, 64/255 },
	white = 0.94,
	darkWhite = 0.82,
	buttonFontSize = 24,
	buttonFontFamily = raleway,
	baseFontFamily = raleway,
	boldFontFamily = raleway_bold,
	flavorFontSize = 18,
}

return theme