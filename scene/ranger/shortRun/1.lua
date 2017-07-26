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
p.spawn = p.centerStage

-- Regions
local r = {}

-- Actors
local a = {
	hero = Actor.new( "DragonChick", { "avatar" } )
}

-- Environment
local e = {
	forest = Scenery.parallaxGroup( {
		key = Scenery.endlessParallax( {
			layer = "front",
			width = 1086,
			height = 640,
			xStart = xn,
			yStart = yn,
			velocity = { -80, 0 },
			period = { 1086, 640 },
			image = "assets/img/training_forest_clearing.png"
		} ),
		minions = {
			Scenery.parallaxMinion( {
				layer = "far",
				width = 1086,
				height = 640,
				xStart = xn,
				yStart = yn,
				ratio = 1/8,
				period = { 1086, 640 },
				image = "assets/img/training_forest_parallax_background.png"
			} ),
			Scenery.parallaxMinion( {
				layer = "mid",
				width = 1086,
				height = 640,
				xStart = xn,
				yStart = yn,
				ratio = 1/4,
				period = { 1086, 640 },
				image = "assets/img/training_forest_parallax_midground.png"
			} ),
			--[[ Scenery.parallaxMinion( {
				layer = "foremost",
				width = 1086,
				height = 640,
				xStart = xn+1086,
				yStart = yn,
				ratio = 4,
				period = { 1086*5, 640 },
				image = "assets/img/training_forest_parallax_front.png"
			} ) --]]
		}
	} )
}

--[[
		Script Creation
--]]

-- Workouts
local w = {}
local w = {}
w.noncore1 = Exercises.new( "ranger", "noncore", 10, w )
w.core1 = Exercises.new( "ranger", "core", 10, w )
w.core2 = Exercises.new( "ranger", "core", 10, w )
w.run = { id = "run", prompt = "Run", anim = "run" }

-- Script Object
local zoneData = { p = p, r = r, a = a, e = e }
local script = {
	Prompt.generate( zoneData, {		
		exercise = w.run,
		duration = ".6 miles",
		isFirst = true,
		commands = {
			commit = function( zone )
				zone.ai:register( e.forest )
			end,
			conclude = function( zone )
				zone.ai:unregister( e.forest )
			end
		}
	} ),

	Prompt.generate( zoneData, {
		exercise = w.noncore1,
		duration = 60
	} ),

	Prompt.generate( zoneData, {		
		exercise = w.run,
		duration = ".6 miles",
		commands = {
			commit = function( zone )
				zone.ai:register( e.forest )
			end,
			conclude = function( zone )
				zone.ai:unregister( e.forest )
			end
		}
	} ),

	Prompt.generate( zoneData, {
		exercise = w.noncore1,
		duration = 60
	} ),

	Prompt.generate( zoneData, {		
		exercise = w.run,
		duration = ".6 miles",
		commands = {
			commit = function( zone )
				zone.ai:register( e.forest )
			end,
			conclude = function( zone )
				zone.ai:unregister( e.forest )
			end
		}
	} ),

	Prompt.generate( zoneData, {
		exercise = w.noncore1,
		duration = 60
	} ),

	Prompt.generate( zoneData, {
		exercise = w.core1,
		duration = 60
	} ),
	Prompt.generate( zoneData, {
		exercise = w.core2,
		duration = 60
	} ),
	Prompt.generate( zoneData, {
		exercise = w.core1,
		duration = 60
	} ),
	Prompt.generate( zoneData, {
		exercise = w.core2,
		duration = 60
	} ),
	Prompt.generate( zoneData, {
		exercise = w.core1,
		duration = 60
	} ),
	Prompt.generate( zoneData, {
		exercise = w.core2,
		duration = 60,
		isFinal = true
	} )
}

-- States
local s = {
	DEFAULT = {
		enter = function( self, zone )
			local a = zone.actors
			zone.ai:activate( a.hero )
		end,
		didShow = function( self, zone, event )
			composer.showOverlay( "scene.welcomeScreen", { params = { parentZone = zone } } )
			zone:enterState( "ACTIVE" )
		end
	},
	ACTIVE = {
		enter = function( self, zone )
			system.setIdleTimer( false )
			zone.pm:init()
		end
	},
	COMPLETE = {
		enter = function( self, zone )
			system.setIdleTimer( true )
			composer.showOverlay( "scene.thankYouScreen", { params = { parentZone = zone } } )
		end
	}
}

-- Zone
local zone = Zone.new( "training_forest", p, r, a, e, s, script )


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