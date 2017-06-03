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
		print( "wander:check called" )
		self.actor:moveToPoint( self.region:point(), self.speed, "quadratic" )
	end

	setmetatable( self, BehaviorMT )
	return self
end

return Behavior