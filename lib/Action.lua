local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Movement = require "lib.Region", require "lib.Movement"
local xn, yn, xo, yo, xf, yf = unpack( data.co )
local tau = 2*math.pi

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
	self.lifetime = self.lifetime + delta
	if self.conditional ~= nil then
		for key, conditional in pairs( self.conditional ) do
			if conditional( self ) then self.contingency[ key ]( self ) end
		end
	end
end

--[[function ActionMT.__concat( action1, action2 )
	action1:callback = function
		self.actor.action = action2
	end
	return action1
end--]]

-- Moves the actor to a given location. Note that, by default, actions do *not* clear
-- themselves on completion.
function Action.moveToPoint( actor, location, animation )
	local self = {
		actor = actor,
		targetLocation = location,
		lifetime = 0,
	}

	actor.movement = Movement.arrive( self.actor, self.targetLocation )
	
	if animation ~= nil then
		self.actor:setAnimation( animation )

		local deltaT
		local d = fn.magnitude( { location.x - actor.steering.position.x, location.y - actor.steering.position.y } )
		local a = actor.steering.acceleration
		local vMax = actor.steering.maxSpeed

		if d <= vMax^2/a then
			deltaT = math.sqrt( 2*d/a )
		else
			deltaT = 2*( vMax/a ) + ( d - vMax^2/a )/vMax
		end

		self.deltaT = deltaT - 0.4 -- animationStateData.defaultMix
		self.hasBegunSlowdown = false

		function self:update( delta )
			print( self.deltaT )
			self.deltaT = self.deltaT - delta
			if self.deltaT <= 0 and not self.hasBegunSlowdown then
				self.actor:setAnimation( "idle" )
				self.hasBegunSlowdown = true
			end
		end

	end

	function self:callback()
		self.actor.movement = nil
		self.actor.action = nil
	end

	setmetatable( self, ActionMT )
	return self
end

-- Actor will move randomly from point to point within a given region
function Action.wanderInRegion( actor, region, options )
	local self = {
		actor = actor,
		region = region,
		currentTarget = region:point(),
		lifetime = 0
	}

	if options ~= nil then
		if options.conditional ~= nil then
			self.conditional = options.conditional
			self.contingency = options.contingency
		end
	else
		self.conditional = {}
		self.contingency = {}
	end

	self.actor.movement = Movement.arrive( self.actor, self.currentTarget )
	function self.conditional:wandercheck()
		return not Movement.checkcelerate( self.actor, self.currentTarget )
	end
	function self.contingency:wandercheck()
		self.currentTarget = self.region:point()
		self.actor.movement = Movement.arrive( self.actor, self.currentTarget )
	end

	setmetatable( self, ActionMT )
	return self
end

return Action