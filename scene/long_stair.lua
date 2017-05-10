--[[
		Initial Declarations
--]]


-- Requirements
local sceneName = "The Long Stair"
local composer = require "composer"
local widget = require "widget"
local util = require "lib.util"


-- Scene Variables
local scene = composer.newScene()
local background, midground, foreground, interface
local sheet_boxLift, sequences_boxLift
local backgroundImage, boxLifter

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
		--boxLifter = display.newSprite( sheet_boxLift, sequences_boxLift )
		--boxLifter.x = 140; boxLifter.y = 390

		--[[
		composer.showOverlay( "scene.encounter_start", { isModal = true, params = {
			name = "The Long Stair",
			} } )
		--]]

	-- Did phase
	elseif phase == "did" then
		--boxLifter:setSequence( "boxLift" ); boxLifter:play()
		--print( preComposer ); print( postComposer )

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