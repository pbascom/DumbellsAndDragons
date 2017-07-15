local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local tau = 2*math.pi
local sin, cos, max, min, deg = math.sin, math.cos, math.max, math.min, math.deg
function cus( theta ) return -1*cos( theta ) end
local random, abs = math.random, math.abs

local Movement = {}
local MovementMT = { __index = Movement }



--[[
		Movement Utility Functions
--]]

-- Returns the smallest difference between two given angles
function Movement.getDifferential( heading, aim )
	local differential = 0
	if fn.sign( sin( heading ) ) == fn.sign( sin( aim ) ) then
		differential = abs( abs( aim ) - abs( heading ) )
		differential = differential*fn.sign( cus( heading ) - cus( aim ) )
	else
		if abs( heading ) + abs( aim ) >= tau/2 then
			differential = abs( heading ) + abs( aim )
			differential = differential*fn.sign( sin( aim ) )
		else
			differential = tau - abs( heading ) - abs( aim )
			differential = -1*differential*fn.sign( sin( aim ) )
		end
	end
	return differential
end

-- Checks whether or not an actor will reach its target at maximum deceleration
function Movement.checkcelerate( actor, target )
	local shouldAccelerate = true
	local stoppingDistance = 0.5*actor.steering.speed*actor.steering.speed/actor.steering.acceleration
	if fn.magnitude( { target.x - actor.group.x, target.y - actor.group.y } ) <= stoppingDistance then shouldAccelerate = false end
	return shouldAccelerate
end

-- Prevents errors for untyped Movements
function Movement:update( delta )
	print( 'I move!' )
end



--[[
		Movement objects
--]]

-- Moves at max speed in specified direction
function Movement.moveInDirection( actor, direction )
	local steering = actor.steering
	local self = {
		actor = actor,
		steering = steering,
		speed = steering.maxSpeed,
		direction = direction
	}

	-- Direction can be given as an angle or as a vector
	if type( self.direction ) == "table" then
		self.direction = fn.angle( self.direction )
	end

	function self:update( delta )
		local dir = self.direction
		local speed = self.speed
		local step = { delta*speed*sin( dir ), delta*speed*cus( dir ) }

		self.actor.group:translate( step[1], step[2] )
		return step
	end

	setmetatable( self, MovementMT )
	return self
end

-- Pursues target at max speed
function Movement.seek( actor, target )
	local steering = actor.steering
	local self = {
		actor = actor,
		steering = steering,
		speed = steering.maxSpeed,
		target = fn.tparse( target )
	}

	steering.speed = steering.maxSpeed

	function self:update( delta )
		local step = self.speed*delta
		local group = self.actor.group
		local disp = fn.normalize( { self.target.x - group.x, self.target.y - group.y } )
		group:translate( step*disp[1], step*disp[2] )
	end

	return self
end

-- Attempts to reach target at zero speed, decelerating whenever it is within stopping distance
-- and accelerating otherwise. Movement patterns this complex and higher must keep the steering
-- object up-to-date, since some of the factors have to be checked mid-movement.
function Movement.arrive( actor, target )
	local steering = actor.steering
	local self = {
		actor = actor,
		steering = steering,
		target = fn.tparse( target )
	}

	function self:update( delta )
		local steering = self.steering
		if Movement.checkcelerate( self.actor, self.target ) then
			steering.speed = min( steering.maxSpeed, steering.speed + steering.acceleration*delta )
		else
			steering.speed = min( steering.maxSpeed, steering.speed - steering.acceleration*delta )
		end
		local step = steering.speed*delta
		local group = self.actor.group
		local disp = { self.target.x - group.x, self.target.y - group.y }
		if fn.magnitude( disp ) >= 1 then
			disp = fn.normalize( disp )
			group:translate( step*disp[1], step*disp[2] )
			return { step*disp[1], step*disp[2] }
		else
			group:translate( step*disp[1], step*disp[2] )
			self.actor.action:callback( "arrive" )
			return { step*disp[1], step*disp[2] }
		end
	end

	return self
end

-- Similar to arrive, but implements angular acceleration and precision.
function Movement.steerTowards( actor, target )
	local steering = actor.steering
	local self = {
		actor = actor,
		steering = actor.steering,
		target = fn.tparse( target )
	}

	if self.steering.precision == nil then self.steering.precision = tau end
	if self.steering.angularAcceleration == nil then self.steering.angularAcceleration = 4000*tau end

	function self:update( delta )
		local a = self.actor
		local t = self.target
		local s = self.steering

		local aim = { t.x - a.group.x, t.y - a.group.y }

		local disp = ( fn.angle( aim ) % tau ) - ( s.orientation % tau )
		local omega = s.angularSpeed
		
		if abs( disp ) > tau/2 then disp = -1*( tau - abs( disp ) ) end

		if abs( disp ) < 0.5*omega^2/s.angularAcceleration then
			omega = max( abs( omega ) - s.angularAcceleration*delta, 0 )
		else
			omega = min( abs( omega ) + s.angularAcceleration*delta, s.maxAngularSpeed )
		end

		s.angularSpeed = fn.sign( disp )*omega
		s.orientation = s.orientation + s.angularSpeed*delta

		if fn.magnitude( aim ) > 0.5*s.speed*s.speed/s.acceleration and abs( disp ) <= s.precision/2 then
			s.speed = min( s.maxSpeed, s.speed + s.acceleration*delta )
		else
			s.speed = max( s.speed - s.acceleration*delta, 0 )
		end

		if fn.magnitude( aim ) > 1 then
			local step = s.speed*delta
			a.group:translate( step*sin( s.orientation ), step*cus( s.orientation ) )
			a.group.rotation = deg( s.orientation + tau/2 )
		end
	end

	return self
end

return Movement