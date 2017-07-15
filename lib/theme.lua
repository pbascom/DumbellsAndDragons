local data = require "lib.data"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local raleway, unifraktur, raleway_bold = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf", "assets/font/Raleway 700.ttf"

local theme = {

	-- Display Settings
	fullWidth = 480,
	fullHeight = 640,

	-- Colors
	green = { 20/255, 204/255, 43/255 },
	darkGreen = { 16/255, 171/255, 23/255 },
	yellow = { 226/255, 216/225, 30/255 },
	darkYellow = { 187/255, 191/255, 64/255 },
	white = 0.94,
	darkWhite = 0.82,

	black = 0.06,
	
	baseFontFamily = raleway,
	boldFontFamily = raleway_bold,

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
	},
	

	-- Prompt UI Theming
	promptBoxPadding = 14,
	promptBoxHeight = yn*3/6,
	promptBoxColor = { 0.3, 0.5 },

	promptFontSize = 24,
	promptNumberSize = 36,
	promptTextPadding = 14,
	promptTextVerticalDisplacement = 84,

	promptBoxVerticalPadding = 14,

	flavorFontSize = 18,
	flavorVerticalDisplacement = 30,


	buttonRadius = 32.5,
	buttonFontSize = 24,
	buttonFontFamily = raleway,

	buttonVerticalPadding = 48,
	buttonHorizontalPadding = 48,

	--[[
			Widget Themes
	--]]
	countdownImageSheet = graphics.newImageSheet( "assets/img/ui/progressBar.png", {
		width = 50,
		height = 50,
		numFrames = 12,
		sheetContentWidth = 300,
		sheetContentHeight = 100
	} ),
	
	countdownWidgetWidth = xf - xo - 80,
	countdownWidgetHeight = 50,
	countdownWidgetFillWidth = 50,
	countdownWidgetFillHeight = 50,
	countdownWidgetFillOuterWidth = 50,
	countdownWidgetFillOuterHeight = 50


}

--Compound Variables

theme.countdownWidgetX = xn
theme.countdownWidgetY = yo + 2*theme.promptTextPadding + theme.promptNumberSize + theme.countdownWidgetHeight/2

theme.buttonBottomCenter = { x = xn, y = yf - theme.buttonRadius - theme.buttonVerticalPadding }
theme.buttonBottomLeft = { x = xo + theme.buttonRadius + theme.buttonHorizontalPadding, y = yf - theme.buttonRadius - theme.buttonVerticalPadding }
theme.buttonBottomRight = { x = xf - theme.buttonRadius - theme.buttonHorizontalPadding, y = yf - theme.buttonRadius - theme.buttonVerticalPadding }

theme.buttonMiddleLeft = { x = xo + theme.buttonRadius + theme.buttonHorizontalPadding, y = yn }
theme.buttonMiddleRight = { x = xf - theme.buttonRadius - theme.buttonHorizontalPadding, y = yn }

return theme