local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Action, Actor = require "lib.Region", require "lib.Action", require "lib.Actor"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local AI = {}

function AI:update( event )
	local currentTime = event.time
	if self.lastTime == 0 then self.lastTime = currentTime end
	local delta = ( currentTime - self.lastTime ) / 1000
	self.lastTime = currentTime

	for i, listener in ipairs( self.listeners ) do
		listener:update( delta )
	end
end

function AI:register( listener )
	if not self.listeners:contains( listener ) then
		table.insert( self.listeners, listener )
	end
end

function AI:unregister( listener )
	for i, l in ipairs( self.listeners ) do
		if l == listener then
			table.remove( self.listeners, i )
		end
	end
end

function AI:activate( ... )
	for i, actor in ipairs( arg ) do
		if not self.listeners:contains( actor ) then
			table.insert( self.listeners, actor )
			actor.group.isVisible = true
		end
	end
end

function AI:deactivate( ... )
	for i, actor in ipairs( arg ) do
		if self.listeners:contains( actor ) then
			table.remove( self.listeners, actor )
			actor.group.isVisible = false
		end
	end
end

function AI:place( actor, point, layer )
	actor.group.x = point.x
	actor.group.y = point.y

	if layer == nil then layer = "foreground" end
	self.zone[ layer ]:insert( actor.group )
end

function AI.new( zone, actors )
	local self = {
		zone = zone,
		actors = actors,

		listeners = {},
		lastTime = 0
	}

	Runtime:addEventListener( "enterFrame", function( event ) self:update( event ) end )

	setmetatable( self, { __index = AI } )
	setmetatable( self.listeners, fn.betterMetatable )
	return self
end

return AI