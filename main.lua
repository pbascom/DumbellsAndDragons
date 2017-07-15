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

-- composer.showOverlay( "scene.splash_screen", { isModal = true } )
-- composer.gotoScene( "scene.map" )
-- composer.gotoScene( "scene.long_stair", { params = { class = "ranger", level = "8" } } )
-- composer.gotoScene( "scene.classHall_ranger" )
-- composer.gotoScene( "scene.ranger_training" )
composer.gotoScene( "scene.training.ranger.shortRun.2" )

--[[
local function print_r ( t ) 
    local print_r_cache={}
        local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                local tLen = #t
                for i = 1, tLen do
                    local val = t[i]
                    if (type(val)=="table") then
                        print(indent.."#["..i.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(i)+8))
                        print(indent..string.rep(" ",string.len(i)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."#["..i..'] => "'..val..'"')
                    else
                        print(indent.."#["..i.."] => "..tostring(val))
                    end
                end
                for pos,val in pairs(t) do
                    if type(pos) ~= "number" or math.floor(pos) ~= pos or (pos < 1 or pos > tLen) then
                        if (type(val)=="table") then
                            print(indent.."["..pos.."] => "..tostring(t).." {")
                            sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                            print(indent..string.rep(" ",string.len(pos)+6).."}")
                        elseif (type(val)=="string") then
                            print(indent.."["..pos..'] => "'..val..'"')
                        else
                            print(indent.."["..pos.."] => "..tostring(val))
                        end
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    
   if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end

   print()
end

print_r( getmetatable( composer.newScene() ) )
--]]