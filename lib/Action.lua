local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region = require "lib.Region"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Action Object Definitions
--]]
local Action = {}
local ActionMT = { __index = Action }

function Action.new( actor )
	local self = {
		actor = actor
	}

	setmetatable( self, ActionMT )
	return self
end

function Action:update( delta )
	print( "By doing nothing, nothing is left undone." )
end

function Action:callback()
	self.actor.action = nil
	self.actor.checkBehavior( { "actionComplete", "generic" } )
end

function Action.moveToPoint( actor, location, speed, easing )
	local self = {
		actor = actor,
		xi = actor.group.x,
		yi = actor.group.y,
		xt = location[1],
		yt = location[2],
		speed = speed,
		distanceTraveled = 0
	}
	self.distanceToTravel = fn.getDistance( {self.xi, self.yi}, location )
	self.xRatio = (self.xt-self.xi)/self.distanceToTravel
	self.yRatio = (self.yt-self.yi)/self.distanceToTravel

	if easing ~= nil then
		if easing == "quadratic" then
			function self:update( delta )
				if self.distanceToTravel - self.distanceTraveled > self.speed / 8 then
					local stepSize = 2*self.speed - (3*self.speed/self.distanceToTravel^2) * (self.distanceTraveled-self.distanceToTravel)^2
					self.actor.group:translate( stepSize*self.xRatio, stepSize*self.yRatio )
					self.distanceTraveled = self.distanceTraveled + speed
				else
					self.actor.group.x = self.xt
					self.actor.group.y = self.yt
					self:callback()
				end
			end
		end
	else
		function self:update( delta )
			if self.distanceToTravel - self.distanceTraveled > self.speed then
				self.actor.group:translate( self.speed*self.xRatio, self.speed*self.yRatio )
				self.distanceTraveled = self.distanceTraveled + speed
			else
				self.actor.group.x = self.xt
				self.actor.group.y = self.yt
				self:callback()
			end
		end
	end

	

	function self:callback()
		self.actor:checkBehavior( { "actionComplete", "moveToPoint" } )
	end

	setmetatable( self, ActionMT )
	return self
end





return Action