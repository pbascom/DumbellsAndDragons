local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local Zone, Region, Actor = require "lib.Zone", require "lib.Region", require "lib.Actor"
local Action, Behavior = require "lib.Action", require "lib.Behavior"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Zone object creation
--]]
local zone = {}

-- Points
local p = {
	baseOfStairs = { x = xn-120, y = yn+240 },
	rocks = { x = xn+90, y = yn+260 },
	stairsBottomLeft = { x = xn-160, y = yn+230 },
	stairsBottomRight = { x = xn-60, y = yn+240 },
	stairsTopLeft = { x = xn+120, y = yn+22 },
	stairsTopRight = { x = xn+124, y = yn+65 },
	offScreenLeft = { x = xn-140, y = yo - 40 },
}

-- Regions
local r = {
	ground = Region.below( p.baseOfStairs, p.rocks ),
	stairs = Region.above( p.stairsBottomLeft, p.stairsBottomRight ) + Region.leftOf( p.stairsBottomRight, p.stairsTopRight ) + Region.rightOf( p.stairsBottomLeft, p.stairsTopLeft )
}

-- Actors
local a = {
	hero = Actor.new( "DragonChick", { "avatar" } )
}

-- States
local s = {
	DEFAULT = {
		enter = function( self, zone )
			local a = zone.actors
			zone.ai:activate( a.hero )
			print( "DEFAULT create" )
		end,
		willShow = function( self, zone, event )
			local a = zone.actors
			local r = zone.regions
			--zone.ai:place( a.hero, p.baseOfStairs )
			zone.ai:place( a.hero, p.rocks )
			print( "DEFAULT willShow" )
		end,
		didShow = function( self, zone, event )
			local a = zone.actors
			local r = zone.regions
			a.hero:setIdle( "airSquat" )
			--a.hero:setIdle( "run" )
			--a.hero.action = Action.wanderInRegion( a.hero, r.ground )
			print( "DEFAULT didShow" )
		end
	}
}

-- Zone
local zone = Zone.new( "long_stair", p, r, a, s )


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