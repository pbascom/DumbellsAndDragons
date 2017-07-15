-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local json = require "json"

local xn, yn, xo, yo, xf, yf = unpack( data.co )

local scene = composer.newScene()

function scene:create( event )

	background = display.newGroup()
	self.view:insert( background )

	local params = event.params

	--Content
	local backgroundImage = display.newImageRect( background, "assets/img/welcomeScreen.jpg", 480, 640 )
	backgroundImage.x = xn; backgroundImage.y = yn

	--Generate UI objects
	local acceptButton = ui.newButton( {
		label = "I'm Ready!",
		fontSize = theme.buttonFontSize,
		fontFamily = theme.buttonFontFamily,
		labelColor = {
			default = theme.white,
			over = theme.darkWhite
		},
		width = 140,
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
			composer.hideOverlay( "slideLeft", 200 )
			params.parentZone:enterState( "ACTIVE" )
		end
	} )
	self.view:insert( acceptButton )
	acceptButton.x = xn
	acceptButton.y = yn + 286

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