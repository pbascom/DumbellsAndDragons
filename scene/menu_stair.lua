--[[
		Initial Declarations
--]]


-- Requirements
local sceneName = "menu_stair"
local composer = require "composer"
local widget = require "widget"; widget.setTheme( "widget_theme_android_holo_light")
local util = require "lib.util"

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local raleway, unifraktur = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf"
local raleway_bold = "assets/font/Raleway 700.ttf"

-- Scene Variables
local scene = composer.newScene()
local background, midground, foreground, interface
local sheet_boxLift, sequences_boxLift
local backgroundImage, boxLifter
local uiScreen, headerText, zoneText, descriptionText, headerLine
local diffPicker, diffText, goButton, goTimer

--[[
		Creation Phase
--]]

function scene:create( event )

	-- Parent View
	local view = self.view

	-- Content layers
	background = display.newGroup()
	view:insert( background )

	midground = display.newGroup()
	view:insert( midground )

	foreground = display.newGroup()
	view:insert( foreground )

	interface = display.newGroup()
	view:insert( interface )

	-- Content
	backgroundImage = display.newImageRect( "assets/img/longStair_bg.png", 480, 640 )
	background:insert( backgroundImage ); backgroundImage.x = 180; backgroundImage.y = 320

	sheet_boxLift = graphics.newImageSheet( "assets/img/boxLift_sprites.png", {
		width = 130,
		height = 212,
		sheetContentWidth = 260,
		sheetContentHeight = 212,
		numFrames = 2
	})

	sequences_boxLift = {
		{
			name = "boxLift",
			start = 1,
			count = 2,
			time = 1200,
			loopCount = 0,
			loopDirection = "foreward"
		}
	}

	--Exercise Start Screen
	uiScreen = display.newRect( interface, xn, yn, width, height )
	uiScreen:setFillColor( 0.15, 0.34, 0.30, 0.65 )

	headerText = display.newText( {
		parent = interface,
		x = xn,
		y = 24,
		text = "The Stony Hills, Zone 2:",
		font = raleway,
		fontSize = 18,
		align = "center"
	} )

	zoneText = display.newText( {
		parent = interface,
		x = xn,
		y = 56,
		text = "The Long Stair",
		font = unifraktur,
		fontSize = 36,
		align = "center"
	} )

	descriptionText = display.newText( {
		parent = interface,
		x = xn,
		y = 92,
		text = "Legs | Endurance | ~20 minutes",
		font = raleway,
		fontSize = 18,
		align = "center"
	} )
	descriptionText:setFillColor( 0.8 )

	headerLine = display.newLine( interface, xn-0.45*width, 118, xn+0.45*width, 118 )
	--headerLine:setStrokeColor( 0.65 )



end



--[[
		Show Phase
--]]

function scene:show( event )

	-- Initialize variables
	local view = self.view
	local phase = event.phase

	-- Will phase
	if phase == "will" then
		--Generate Scene objects
		boxLifter = display.newSprite( sheet_boxLift, sequences_boxLift )
		foreground:insert( boxLifter ); boxLifter.x = 140; boxLifter.y = 390

		--Generate UI objects
		avatar = display.newImageRect( "assets/img/avatar_heroic.png", 220, 365 )
		interface:insert( avatar ); avatar.x = 110; avatar.y = 450

		diffText = display.newText( {
			parent = interface,
			align = "left",
			x = 92,
			y = 144,
			text = "Difficulty:",
			font = raleway,
			fontSize = 22
		} )
		diffPicker = display.newText( {
			parent = interface,
			align = "left",
			x = 180,
			y = 144,
			text = "EASY",
			font = raleway_bold,
			fontSize = 22
		} )
		diffPicker:setFillColor( 0.1, 0.9, 0.2 )

		goButton = display.newImageRect( interface, "assets/img/go_button.png", 156, 156 )
		goButton.x = 265; goButton.y = 244


	-- Did phase
	elseif phase == "did" then
		function beginWorkout()
			interface.alpha = 0; interface.y = -4000
			boxLifter:setSequence( "boxLift" ); boxLifter:play()
		end
		goButton:addEventListener( "tap", beginWorkout )
	end
end



--[[
		Hide Phase
--]]

function scene:hide( event )

	local view = self.view

end



--[[
		Destroy Phase
--]]

function scene:destroy( event )

	local view = self.view

end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene







--[[
		Load Display Groups
--]]






--[[
		Load sprite sheets
--]]
