--[[
		Initial Declarations
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local json = require "json"
local transition = require "transition"

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
	backgroundImage = display.newImageRect( background, "assets/img/splashPage.jpg", 480, 640 )
	backgroundImage.x = xn; backgroundImage.y = yn

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

		timer.performWithDelay( 1000, function()
			transition.to( backgroundImage, {
				time = 600,
				alpha = 0,
				onComplete = function()
					composer.gotoScene( "scene.ranger_training" )
				end
				} )
		end )

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