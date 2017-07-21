local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local Zone, Region, Actor = require "lib.Zone", require "lib.Region", require "lib.Actor"
local Action, Behavior = require "lib.Action", require "lib.Behavior"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Scene object creation
--]]

-- Scene Variables
local scene = composer.newScene()
local background, midground, foreground, interface
local map, mbutton, uibutton, uiTray, uiTrayShadow

local view, phase, params

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local buttonWidth = width/5.25; local buttonPadding = buttonWidth/4


function getGoTo( scene, options )
	function goTo( event )
		composer.gotoScene( "scene." .. scene, options )
	end
	return goTo
end

local scene = composer.newScene()

function scene:create( event )
		-- Parent View
	view, params = self.view, event.params

	-- Content layers
	background = display.newGroup()
	view:insert( background )

	midground = display.newGroup()
	view:insert( midground )

	foreground = display.newGroup()
	view:insert( foreground )

	interface = display.newGroup()
	view:insert( interface )

	local backgroundImage = display.newImageRect( background, "assets/img/classHall_ranger_background.jpg", 480, 640 )
	backgroundImage.x = xn; backgroundImage.y = yn

	local screen = fx.newRect( xn, yn-20, 320, 120, { 0.3, 0.6} )
	interface:insert( screen )

	local titleText = display.newText({
		text = "Sample Workouts:",
		font = theme.raleway,
		fontSize = 24
	})
	interface:insert( titleText )
	titleText:setFillColor( 0.84 )
	titleText.x = xn
	titleText.y = yn - 60

	local firstWorkout = ui.newImageButton({
		hitWidth = 60,
		hitHeight = 60,
		imageHeight = 80,
		imageWidth = 80,
		image = "icon_blank",
		symbol = "I",
		fontFamily = theme.raleway_bold,
		fontSize = 24,
		symbolColor = { default = 0.94, over = 0.85 },
		callback = getGoTo( "ranger.shortRun.1" )
	})
	interface:insert( firstWorkout )
	firstWorkout.x = xn - 120
	firstWorkout.y = yn

	local secondWorkout = ui.newImageButton({
		hitWidth = 60,
		hitHeight = 60,
		imageHeight = 80,
		imageWidth = 80,
		image = "icon_blank",
		symbol = "II",
		fontFamily = theme.raleway_bold,
		fontSize = 24,
		symbolColor = { default = 0.94, over = 0.85 },
		callback = getGoTo( "ranger.shortRun.2" )
	})
	interface:insert( secondWorkout )
	secondWorkout.x = xn - 40
	secondWorkout.y = yn

	local thirdWorkout = ui.newImageButton({
		hitWidth = 60,
		hitHeight = 60,
		imageHeight = 80,
		imageWidth = 80,
		image = "icon_blank",
		symbol = "III",
		fontFamily = theme.raleway_bold,
		fontSize = 24,
		symbolColor = { default = 0.94, over = 0.85 },
		callback = getGoTo( "ranger.shortRun.3" )
	})
	interface:insert( thirdWorkout )
	thirdWorkout.x = xn + 40
	thirdWorkout.y = yn

	local fourthWorkout = ui.newImageButton({
		hitWidth = 60,
		hitHeight = 60,
		imageHeight = 80,
		imageWidth = 80,
		image = "icon_blank",
		symbol = "IV",
		fontFamily = theme.raleway_bold,
		fontSize = 24,
		symbolColor = { default = 0.94, over = 0.85 },
		callback = getGoTo( "ranger.shortRun.4" )
	})
	interface:insert( fourthWorkout )
	fourthWorkout.x = xn + 120
	fourthWorkout.y = yn

end

function scene:show( event )
	if event.phase == "will" then
		composer.showOverlay( "scene.splash_screen")
	elseif event.phase == "did" then
	end
end

function scene:hide( event )
	if event.phase == "will" then
	elseif event.phase == "did" then
	end
end

function scene:destroy( event )
end


--[[
		Listeners & Runtime Integration
--]]
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene