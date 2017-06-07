-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--[[
		Load data, if necessary.
--]]
local function exists( fname, path )
 
    local results = false
 
    -- Path for the file
    local filePath = system.pathForFile( fname, path )
 
    if ( filePath ) then
        local file, errorString = io.open( filePath, "r" )

        if file then
            results = true
            file:close()
        end
    end
 
    return results
end

if not exists( "chars.json", system.DocumentsDirectory ) then
	local file = io.open( system.pathForFile( "chars.json", system.DocumentsDirectory ), "w" )
	file:write('{"name": "marek","stat": {"1": 16,"2": 14, "3": 15,"4": 13},"class": {"fighter": 12,"ranger": 6,},"activeClass": "fighter"}')
	file:close()
end

if not exists( "stair.json", system.DocumentsDirectory ) then
	local file = io.open( system.pathForFile( "stair.json", system.DocumentsDirectory ), "w" )
	file:write('{"fighter": {"assets": {"motions": ["run", "squat"],"animations": ["run", "airSquat", "runUpStairs"]},"2": [{"prompt": { "motion": "run", "distance": 400 },"animation": { "hero": "run" }},{"prompt": { "motion": "airSquat", "number": 15 },"animation": { "hero": "airSquat" }},{"prompt": { "motion": "run", "distance": 400 },"animation": { "hero": "run" }},{"prompt": { "motion": "airSquat", "number": 15 },"animation": { "hero": "airSquat" }},{"prompt": { "motion": "run", "distance": 400 },"animation": { "hero": "run" }},{	"prompt": { "motion": "airSquat", "number": 15 },"animation": { "hero": "airSquat" }},],"8": [{"prompt": { "motion": "run", "distance": 800 },"animation": { "hero": "run" }},{	"prompt": { "motion": "airSquat", "number": 30 },"animation": { "hero": "airSquat" }},{	"prompt": { "motion": "run", "distance": 800 },	"animation": { "hero": "run" }},{"prompt": { "motion": "airSquat", "number": 30 },"animation": { "hero": "airSquat" }},{"prompt": { "motion": "run", "distance": 800 },	"animation": { "hero": "run" }},{"prompt": { "motion": "airSquat", "number": 30 },"animation": { "hero": "airSquat" }}]},"ranger": {"assets": {	"motions": ["run", "bike"],	"animations": ["run", "runUpStairs"]},"2": [{"prompt": { "motion": "run", "distance": 800 },"animation": { "hero": "run" }},{"prompt": { "motion": "bike", "distance": 1600 },"animation": { "hero": "runUpStairs" }},{	"prompt": { "motion": "run", "distance": 800 },	"animation": { "hero": "run" }}],"8": [	{"prompt": { "motion": "run", "distance": 1600 },"animation": { "hero": "run" }},{"prompt": { "motion": "bike", "distance": 3200 },"animation": { "hero": "runUpStairs" }},{"prompt": { "motion": "run", "distance": 1600 },"animation": { "hero": "run" }}]}}')
	file:close()
end


--[[
		Get to the app!
--]]
local composer = require "composer"
local widget = require "widget"
local fn = require "lib.fn"
local raleway, unifraktur = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf"
local raleway_bold = "assets/font/Raleway 700.ttf"

local titleBar, titleText, hamburger
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY




-- Interface

--[[ I don't like the bar.
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

titleText:addEventListener( "tap", function()
	composer.hideOverlay()
	composer.gotoScene( "scene.map" )
	
end )

hamburger = widget.newButton({
	width = 28,
	height = 28,
	x = 20+xn-width/2,
	y = 20,
	defaultFile = "assets/img/ui/hamburger.png",
	isEnabled = true
})
hamburger.alpha = 0.5
--]]

-- composer.gotoScene( "scene.map" )
-- composer.gotoScene( "scene.long_stair", { params = { class = "ranger", level = "2" } } )
composer.gotoScene( "scene.object_stair", { params = { class = "ranger", level = "2" } } )