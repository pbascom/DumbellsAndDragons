--[[
		Initial Declarations
--]]


-- Requirements
local composer = require "composer"
local widget = require "widget"
local fn = require "lib.fn"
local fx = require "lib.fx"

-- Scene Variables
local view, parent, params, phase
local scene = composer.newScene()
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local raleway, unifraktur, raleway_bold = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf", "assets/font/Raleway 700.ttf"
local uiScreen, headerText, zoneText, descriptionText, headerLine
local diffPicker, diffText, goButton, goTimer


--[[
		Creation Phase
--]]

function scene:create( event )

	-- Parent View
	view, parent, params = self.view, event.parent, event.params

	--Content
	uiScreen = display.newRect( view, xn, yn, width, height )
	uiScreen:setFillColor( 0.15, 0.34, 0.30, 0.65 )

	headerText = display.newText( {
		parent = view,
		x = xn,
		y = 24,
		text = "The Stony Hills, Zone 2:",
		font = raleway,
		fontSize = 18,
		align = "center"
	} )

	zoneText = display.newText( {
		parent = view,
		x = xn,
		y = 56,
		text = "The Long Stair",
		font = unifraktur,
		fontSize = 36,
		align = "center"
	} )

	descriptionText = display.newText( {
		parent = view,
		x = xn,
		y = 92,
		text = "Legs | Endurance | ~20 minutes",
		font = raleway,
		fontSize = 18,
		align = "center"
	} )
	descriptionText:setFillColor( 0.8 )

	headerLine = display.newLine( view, xn-0.45*width, 118, xn+0.45*width, 118 )
	--headerLine:setStrokeColor( 0.65 )



end



--[[
		Show Phase
--]]

function scene:show( event )

	-- Initialize variables
	phase, parent = event.phase, event.parent

	-- Will phase
	if phase == "will" then
		--Generate UI objects
		avatar = display.newImageRect( "assets/img/avatar_heroic.png", 220, 365 )
		view:insert( avatar ); avatar.x = 110; avatar.y = 450

		diffText = display.newText( {
			parent = view,
			align = "left",
			x = 92,
			y = 144,
			text = "Difficulty:",
			font = raleway,
			fontSize = 22
		} )
		diffPicker = display.newText( {
			parent = view,
			align = "left",
			x = 180,
			y = 144,
			text = "EASY",
			font = raleway_bold,
			fontSize = 22
		} )
		diffPicker:setFillColor( 0.1, 0.9, 0.2 )

		goButton = display.newImageRect( view, "assets/img/go_button.png", 156, 156 )
		goButton.x = 265; goButton.y = 244


	-- Did phase
	elseif phase == "did" then
		function beginWorkout()
			composer.hideOverlay( "slideDown", 300 )
			parent:startWorkout()
		end
		goButton:addEventListener( "tap", beginWorkout )
	end
end



--[[
		Hide Phase
--]]

function scene:hide( event )


end



--[[
		Destroy Phase
--]]

function scene:destroy( event )


end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene