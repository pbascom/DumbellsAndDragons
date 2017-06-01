--[[
		Initial Declarations
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local json = require "json"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

-- Encounter Variables
local name, id = "The Long Stair", "stair"
local source, assets, script
local lastTime = 0

-- Scene Variables
local view, phase, params, source
local scene = composer.newScene()
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local background, midground, foreground, interface
local backgroundImage, hero, heroics, prompts
local pauseButton, playButton
local flavorText, prompt, promptQuantity, promptBackground

local stateTemplate = {
	willShow = function( event )
	end,
	didShow = function( event )
	end,
	willHide = function( event )
	end,
	didHide = function( event )
	end,
	enter = function( event )
	end
}

local READY = {
	willShow = function( event )

		--[[ Show encounter splash screen
		composer.showOverlay( "scene.encounter_splash", { isModal = true, params = {
			id = id,
			description = "The path is steep and jagged, a crude stair that winds into the Hills and vanishes out of sight. This journey won't be easy.",
			duration = "25 minutes",
			equipment = "Track or Treadmill, Exercise Mat",
		} } ) --]]

		-- Build UI
		playButton = ui.newCircleButton( {
			radius = 32.5,
			color = {
				default = theme.green,
				over = theme.darkGreen
			},
			label = "Begin",
			fontSize = theme.buttonFontSize,
			fontFamily = theme.buttonFontFamily,
			labelColor = {
				default = theme.white,
				over = theme.darkWhite
			},
			labelShadow = true,
			icon = "playIcon",
			iconColor = {
				default = theme.white,
				over = theme.darkWhite
			},
			shadowOffsetX = 2,
			shadowOffsetY = 2,
			shadowSize = 12,
			shadowOpacity = 0.5,
			callback = function( event )
				print( "callback called" )
			end
		} )
		interface:insert( playButton )

		pauseButton = ui.newCircleButton( {
			radius = 32.5,
			color = {
				default = theme.yellow,
				over = theme.darkYellow
			},
			label = "Pause",
			fontSize = theme.buttonFontSize,
			fontFamily = theme.buttonFontFamily,
			labelColor = {
				default = theme.white,
				over = theme.darkWhite
			},
			icon = "pauseIcon",
			iconColor = {
				default = theme.white,
				over = theme.darkWhite
			},
			labelShadow = true,
			shadowOffsetX = 2,
			shadowOffsetY = 2,
			shadowSize = 12,
			shadowOpacity = 0.5,
			callback = function( event )
				print( "callback called" )
			end
		} )
		interface:insert( pauseButton )
		pauseButton.x, pauseButton.y = xn, height - 80
		pauseButton.isVisible = false

		-- Place sprites in initial positions
		hero.group.x = xn - 110; hero.group.y = yn + 245

	end,
	didShow = function( event )

		-- Start initial animations
		heroics:setAnimationByName( 1, "idle", true )
		heroics:setAnimationByName( 2, "lookUp" )
		print( heroics.tracks[2].alpha )
		heroics.tracks[2].alpha = 0.65

		-- Place initial UI
		promptBackground = fx.newRect( xn, 3*height/16, width-80, height/4, { 0.3, 0.5 } )
		interface:insert( promptBackground )

		flavorText = fx.newShadowText( {
			parent = interface,
			text = "Nothing to do but climb...",
			x = xn,
			y = 3*height/16 - 50,
			font = theme.baseFontFamily,
			fontSize = theme.flavorFontSize,
			color = theme.white,
			align = "center",
			shadowOffsetX = 2,
			shadowOffsetY = 2,
			shadowSize = 12,
			shadowOpacity = 0.8,
		} )

		prompt = fx.newShadowText( {
			parent = interface,
			text = "Air Squats",
			x = xn + 20,
			y = 3*height/16+10,
			font = theme.boldFontFamily,
			fontSize = 24,
			color = theme.white,
			align = "center",
			shadowOffsetX = 2,
			shadowOffsetY = 2,
			shadowSize = 12,
			shadowOpacity = 0.8,
		} )

		promptQuantity = fx.newShadowText( {
			parent = interface,
			text = "15",
			x = xn - 75,
			y = 3*height/16+10,
			font = theme.baseFontFamily,
			fontSize = 36,
			color = theme.green,
			align = "center",
			shadowOffsetX = 2,
			shadowOffsetY = 2,
			shadowSize = 12,
			shadowOpacity = 0.8,
		} )

		playButton.x, playButton.y = xn, 5*height/16
		playButton.isVisible = true
		playButton:toFront()

	end
}

local promptCycle = {
	
}

local promptState = {
	
}

local state = READY


--[[
		Creation Event
--]]

function scene:create( event )

	-- Load Assets
	params = event.params
	local path = system.pathForFile( "" .. id .. ".json", system.DocumentsDirectory )
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

	interface = display.newGroup()
	view:insert( interface )
	interface.x, interface.y = xn-width/2, yn-height/2 --Letterbox correction

	-- Prep Content: first we start with static images
	backgroundImage = display.newImageRect( "assets/img/longStair_bg.png", 480, 640 )
	background:insert( backgroundImage ); backgroundImage.x = xn; backgroundImage.y = yn

	-- Next, sprites and changeables. Note: first we make it work, then we generalize.
	local data = fn.loadSkeleton( "legodude", 0.25 )
	hero, heroics = data.skeleton, data.state
	foreground:insert( hero.group )

	Runtime:addEventListener( "enterFrame", function( event )
		local currentTime = event.time/1500
		local delta = currentTime - lastTime
		lastTime = currentTime

		hero.group.isVisible = true

		heroics:update(delta)
		heroics:apply(hero)
		hero:updateWorldTransform()
	end )


	local stairPolygon = display.newPolygon( xn, yn + height/2 - 39, { xn-width/2 + 4, height-4, xn-width/2 + 4, height-80, xn+width/2 - 4, height - 60, xn + width/2 - 4, height - 4 } )
	--stairPolygon:setFillColor( 0.4, 1, 0.4, 0.7 )


end



--[[
		Show Event
--]]

function scene:show( event )
	phase = event.phase

	--[[
			Will phase
	--]]
	if phase == "will" then
		state.willShow( event )

	--[[
			Did phase
	--]]
	elseif phase == "did" then
		state.didShow( event )

	end
end


--[[
		Workout start
--]]

function scene:startWorkout()
		hero.group.x, hero.group.y = xn, yn+140
		heroics:setEmptyAnimation( 0, 0 )
		--timer = ui.newTimer( interface, xn, 80, width-80, 50, "countdown", "blue", 60 )
		popButton = fx.buttonPop()
		interface:insert( popButton )
		popButton.x = xn; popButton.y = yn
		popButton:addEventListener( "tap", function(event)
			popButton:pop()
		end )
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