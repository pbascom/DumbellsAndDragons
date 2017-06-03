local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Action, Actor = require "lib.Region", require "lib.Action", require "lib.Actor"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local AI = {}
local AIMT = { __index = AI }

function AI.new()
	local self = {
		lastTime = 0,
		actors = {}
	}

	function self:update( event )
		local currentTime = event.time
		if self.lastTime == 0 then self.lastTime = currentTime end
		local delta = currentTime - self.lastTime
		self.lastTime = currentTime

		for index, actor in ipairs( self.actors ) do
			actor:act( delta )
		end
	end

	function self:register( actor )
		if type( self.actors ) ~= "table" then
			self.actors = {}
		end
		table.insert( self.actors, actor )
		return actor
	end

	setmetatable( self, AIMT )

	Runtime:addEventListener( "enterFrame", function( event ) self:update( event ) end )

	return self
end

return AI