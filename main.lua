-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require "composer"
local widget = require "widget"
local util = require "lib.util"
local raleway, unifraktur = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf"
local raleway_bold = "assets/font/Raleway 700.ttf"

local titleBar, titleText, hamburger
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY


-- Interface
titleBar = display.newRect( xn, 20, width, 40)
titleBar:setFillColor( 0.2 )

titleText = display.newText({
	text = "Dumbbells & Dragons",
	x = xn,
	y = 20,
	font = unifraktur,
	fontSize = 32,
	align = "center"
})

hamburger = widget.newButton({
	width = 28,
	height = 28,
	x = 20,
	y = 20,
	defaultFile = "assets/img/ui/hamburger.png",
	isEnabled = true
})
hamburger.alpha = 0.5

composer.gotoScene( "scene.adjustable_stair", { params = { class = "ranger", level = "2" } } )