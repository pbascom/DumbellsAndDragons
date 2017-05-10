--[[
		Initial Declarations
--]]


-- Requirements
local composer = require "composer"
local widget = require "widget"
local json = require "json"
local spine = require "lib.spine"
local util = require "lib.util"

-- Encounter Variables
local name, id = "The Long Stair", "stair"
local source, assets, script
local lastTime = 0

-- Scene Variables
local view, phase, params
local scene = composer.newScene()
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local background, midground, foreground, interface
local backgroundImage, hero, heroics


--[[
		Creation Event
--]]

function scene:create( event )

	-- Load Assets
	params = event.params
	local path = "D:/Calliope/Demo/data/"..id..".json" --Replace with System.pathForFile before building
	local file, errorString = io.open( path, "r" )
	if not file then
		print("File Error: " .. errorString)
	else
		source = json.decode( file:read( "*a" ) )
	end
	io.close()

	assets = source[params.class].assets; script = source[ params.class ][ params.level ]
	print( params.class, assets.motions[1], script[1].prompt.motion )

	-- Prepare display groups
	view = self.view

	background = display.newGroup()
	view:insert( background )

	midground = display.newGroup()
	view:insert( midground )

	foreground = display.newGroup()
	view:insert( foreground )

	-- Prep Content: first we start with static images
	backgroundImage = display.newImageRect( "assets/img/longStair_bg.png", 480, 640 )
	background:insert( backgroundImage ); backgroundImage.x = xn; backgroundImage.y = yn

	-- Next, sprites and changeables. Note: first we make it work, then we generalize.
	local data = util.loadSkeleton( "legodude", 0.25 )
	hero, heroics = data.skeleton, data.state
	foreground:insert( hero.group )

	Runtime:addEventListener( "enterFrame", function (event)
		local currentTime = event.time/1500
		local delta = currentTime - lastTime
		lastTime = currentTime

		hero.group.isVisible = true

		heroics:update(delta)
		heroics:apply(hero)
		hero:updateWorldTransform()
	end )

end



--[[
		Show Event
--]]

function scene:show( event )
	phase= event.phase

	--[[
			Will phase
	--]]
	if phase == "will" then
		-- Place and prepare skeletons
		hero.group.x, hero.group.y = xn, height-40

		-- Load encounter start screen with params
		composer.showOverlay( "scene.encounter_start" )

		

	--[[
			Did phase
	--]]
	elseif phase == "did" then
		heroics:setAnimationByName( 0, "run", true )

	end
end



--[[
		Hide Event
--]]

function scene:hide( event )


end



--[[
		Destroy Phase
--]]

function scene:destroy( event )

	view = self.view

end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene