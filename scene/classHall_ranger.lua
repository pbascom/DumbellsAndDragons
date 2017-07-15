local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local Zone, Region, Actor = require "lib.Zone", require "lib.Region", require "lib.Actor"
local Action, Behavior = require "lib.Action", require "lib.Behavior"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Zone object creation
--]]
local p = {
	floorTopLeft = { x = xn-15, y = yn+90 },
	floorTopRight = { x = xn+30, y = yn+90 },
	floorBottomLeft = { x = xn-140, y = yn+320 },
	floorBottomRight = { x = xn+100, y = yn+320 },
	tabletopLeft = { x = xn-112, y = yn+52 },
	tabletopRight = { x = xn-50, y = yn+52 },
	tabletopTop = { x = xn-80, y = yn+47 },
	tabletopBottom = { x = xn-80, y = yn+60 }
}

local r = {
	floor = Region.below( p.floorTopLeft, p.floorTopRight ) + Region.rightOf( p.floorTopLeft, p.floorBottomLeft ) + Region.leftOf( p.floorTopRight, p.floorBottomRight ),
	tabletop = Region.rightOf( p.tabletopLeft ) + Region.leftOf( p.tabletopRight ) + Region.above( p.tabletopBottom ) + Region.below( p.tabletopTop )
}

local a = {
	george = Actor.new( "LegoDude", { "npc" } ),
	harold = Actor.new( "LegoDude", { "npc" } ),
	margery = Actor.new( "LegoDude", { "npc" } )
}

local s = {
	DEFAULT = {
		enter = function( self, zone )
			local a = zone.actors
			zone.ai:activate( a.george, a.harold )
			zone.ai:deactivate( a.margery )
			print( "DEFAULT create" )
		end,
		willShow = function( self, zone, event )
			local a = zone.actors
			local r = zone.regions
			zone.ai:place( a.george, r.tabletop:point() )
			zone.ai:place( a.harold, r.floor:point() )
			print( "DEFAULT willShow" )
		end,
		didShow = function( self, zone, event )
			local a = zone.actors
			local r = zone.regions
			a.george:setIdle( "airSquat" )
			a.harold:setIdle( "run" )
			a.harold.action = Action.wanderInRegion( a.harold, r.floor )
			print( "DEFAULT didShow" )
		end
	}
}

local zone = Zone.new( "classHall_ranger", p, r, a, s )


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