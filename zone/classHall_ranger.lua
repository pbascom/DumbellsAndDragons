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
	floorTopLeft = { xn-15, yn+90 },
	floorTopRight = { xn+30, yn+90 },
	floorBottomLeft = { xn-140, yn+320 },
	floorBottomRight = { xn+100, yn+320 },
	tabletopLeft = { xn-112, yn+52 },
	tabletopRight = { xn-50, yn+52 },
	tabletopTop = { xn-80, yn+47 },
	tabletopBottom = { xn-80, yn+60 }
}

local r = {
	floor = Region.below( p.floorTopLeft, p.floorTopRight ) + Region.rightOf( p.floorTopLeft, p.floorBottomLeft ) + Region.leftOf( p.floorTopRight, p.floorBottomRight ),
	tabletop = Region.rightOf( p.tabletopLeft ) + Region.leftOf( p.tabletopRight ) + Region.above( p.tabletopBottom ) + Region.below( p.tabletopTop )
}

local a = {
	george = Actor.new( "legodude", { "npc" } ),
	harold = Actor.new( "legodude", { "npc" } ),
	margery = Actor.new( "legodude", { "npc" } )
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
			-- a.george:setBehavior( Behavior.repeatRandomly( { action = "face", args } ), 20, 10 )
			a.harold:setBehavior( Behavior.wanderRandomlyInRegion( a.harold, r.floor, 30, 20 ) )
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