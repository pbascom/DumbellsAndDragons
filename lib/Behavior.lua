local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Action = require "lib.Region", require "lib.Action"
local xn, yn, xo, yo, xf, yf = unpack( data.co )



local Behavior = {}
local BehaviorMT = { __index = Behavior }

function Behavior.new( actor )
	local self = {
		actor = actor
	}
	setmetatable( self, BehaviorMT )
	return self
end

function Behavior:check( reasons )
	self.actor:setAction( Action.new() )
end

function Behavior.wander( actor, region, speed )
	local self = {
		actor = actor,
		region = region,
		speed = speed
	}

	function self:check( reasons )
		self.actor:moveToPoint( self.region:point(), self.speed, "quadratic" )
	end

	setmetatable( self, BehaviorMT )
	return self
end

function Behavior.repeatRandomly( actor, action, mu, sigma )
	local self = {
		actor = actor,
		mu = mu,
		sigma = sigma,
		timer = 0,
		action = action
	}

	function self:update( delta )
		self.timer = self.timer - delta
		print( self.timer )
		if self.timer <= 0 then
			self.actor:setAction( Action[ self.action[1] ]( unpack( self.action[2] ) ) )
			self.ai:unregister( self )
		end
	end

	function self:check( reasons )
		print( "repeatChecked" )
		if reasons == "actionComplete" or reasons == "init" then
			self.timer = mu + fn.randomBinomial()*sigma
			self.ai:register( self )
		end
	end

	setmetatable( self, BehaviorMT )
	return self
end

function Behavior.wanderRandomlyInRegion( actor, region, mu, sigma )
	local self = {
		actor = actor,
		ai = actor.ai,
		region = region,
		mu = mu,
		sigma = sigma,
		timer = 0,
	}

	function self:update( delta )
		self.timer = self.timer - delta
		print( self.timer )
		if self.timer <= 0 then
			self.actor:moveToPoint( self.region:point() )
			self.ai:unregister( self )
		end
	end

	function self:check( reasons )
		print( "repeatChecked" )
		if reasons[1] == "actionComplete" or reasons[1] == "init" then
			self.timer = mu + fn.randomBinomial()*sigma
			self.ai:register( self )
		end
	end

	setmetatable( self, BehaviorMT )
	return self
end

return Behavior