--[[
		Initial Declarations
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local json = require "json"

-- Scene Variables
local view, parent, params, phase
local scene = composer.newScene()
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local raleway, unifraktur, raleway_bold = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf", "assets/font/Raleway 700.ttf"

local background, foreground
local backgroundImage, backgroundFade, description, duration, equipment
local acceptButton

--[[
		Creation Phase
--]]

function scene:create( event )

	-- Parent View
	view, parent, params = self.view, event.parent, event.params

	background = display.newGroup()
	view:insert( background )

	foreground = display.newGroup()
	view:insert( foreground )

	--Content
	backgroundImage = display.newImageRect( background, "assets/img/" .. params.id .. "_splash.png", 480, 640 )
	backgroundImage.x = xn; backgroundImage.y = yn

	backgroundFade = display.newImage( background, "assets/img/ui/gradientFade.png", 480, 640 )
	backgroundFade.x = xn; backgroundFade.y = yn

	--Generate UI objects
	acceptButton = ui.newButton( {
		label = "Ready",
		fontSize = theme.buttonFontSize,
		fontFamily = theme.buttonFontFamily,
		labelColor = {
			default = theme.white,
			over = theme.darkWhite
		},
		width = 120,
		height = 40,
		radius = 8,
		color = {
			default = theme.green,
			over = theme.darkGreen
		},
		shadowOffsetX = 2,
		shadowOffsetY = 2,
		shadowSize = 12,
		shadowOpacity = 0.5,
		callback = function( event )
			composer.hideOverlay( "slideLeft", 300 )
		end
	} )
	foreground:insert( acceptButton )
	acceptButton.x = width/2 + xn - 80
	acceptButton.y = height/2 + yn - 76

	description = display.newText( {
		parent = foreground,
		x = xn,
		y = yn + 140,
		text = params.description,
		font = raleway,
		fontSize = 18,
		width = width - 80,
		align = "left"
	} )
	description:setFillColor( 0.9 )
		duration = display.newText( {
		parent = foreground,
		width = width - 180,
		x = width/2 - 70,
		y = height/2 + yn - 114,
		text = "Duration: " .. params.duration,
		font = "raleway",
		sontSize = 18,
		align = "left"
	} )
	duration:setFillColor( 0.9 )
		equipment = display.newText( {
		parent = foreground,
		width = width - 180,
		x = width/2 - 70,
		y = height/2 + yn - 60,
		text = "Equipment: " .. params.equipment,
		font = "raleway",
		fontSize = 18,
		align = "left"
	} )
	equipment:setFillColor( 0.9 )

end



--[[
		Show Phase
--]]

function scene:show( event )

	-- Initialize variables
	phase, parent = event.phase, event.parent

	-- Will phase
	if phase == "will" then

	-- Did phase
	elseif phase == "did" then

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