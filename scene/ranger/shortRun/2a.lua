local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local Zone, Region, Actor, Prompt = require "lib.Zone", require "lib.Region", require "lib.Actor", require "lib.Prompt"
local Action, Behavior, Scenery = require "lib.Action", require "lib.Behavior", require "lib.Scenery"
local Widget, Exercises = require "lib.Widget", require "lib.Exercises"
local DisplayManager, PromptMachine = require "lib.DisplayManager", require "lib.PromptMachine"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Zone object creation
--]]
-- Points
local p = {
	centerStage = { x = xn, y = yf-80 },
	stageLeft = { x = xo+80, y = yf-80 },
	stageRight = { x = xf-80, y = yf-80 }
}

-- Regions
local r = {}

-- Actors
local a = {}

-- States
local s = {}

-- Zone
local zone = Zone.new( "id", p, r, a, s )


--[[
		Scene object creation
--]]
local scene = composer.newScene()

function scene:create( event )
	zone:create( self, event )
end

function scene:show( event )
	if event.phase == "will" then
		zone:willShow( event )
	elseif event.phase == "did" then
		zone:didShow( event )
	end
end

function scene:hide( event )
	if event.phase == "will" then
		zone:willHide( event )
	elseif event.phase == "did" then
		zone:didShow( event )
	end
end

function scene:destroy( event )
	zone:destroy( event )
end


--[[
		Listeners & Runtime Integration
--]]
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene