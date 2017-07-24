local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region = require "lib.Region"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local abs = math.abs
local tau = 2*math.pi

local Scenery = {}
local SceneryMT = { __index = Scenery }

--[[
		Utility / Metatable methods
--]] 
function Scenery:place( zone )
	local target = self.image
	if self.group ~= nil then target = self.group end
	if self.layer == nil then self.layer = "near" end

	if self.layer == "far" then zone.parallaxFar:insert( target )
	elseif self.layer == "mid" then zone.parallaxMid:insert( target )
	elseif self.layer == "near" then zone.parallaxNear:insert( target )
	elseif self.layer == "front" then zone.parallaxFront:insert( target )
	end
end

--[[
		Object Creation methods
--]]
function Scenery.endlessParallax( options )
	local self = {
		group = display.newGroup(),
		layer = options.layer,

		width = options.width,
		height = options.height,
		velocity = options.velocity,
		period = options.period,

		distanceTraveled = { 0, 0 }
	}

	self.image = display.newImageRect( options.image, options.width, options.height )
	self.group:insert( self.image )
	self.image.x = options.xStart
	self.image.y = options.yStart

	self.follower = display.newImageRect( options.image, options.width, options.height )
	self.group:insert( self.follower)
	self.follower.x = options.xStart + options.period[1]*-1*fn.sign( self.velocity[1] )
	self.follower.y = options.yStart + options.period[2]*-1*fn.sign( self.velocity[2] )

	function self:update( delta )
		local step = { self.velocity[1]*delta, self.velocity[2]*delta }
		self.image:translate( step[1], step[2] )
		self.follower:translate( step[1], step[2] )
		self.distanceTraveled = { self.distanceTraveled[1]+abs( step[1] ), self.distanceTraveled[2]+abs( step[2] ) }

		local reset = false
		if self.distanceTraveled[1] >= self.period[1] then
			self.distanceTraveled[1] = self.distanceTraveled[1] - self.period[1]
			reset = true
		end
		if self.distanceTraveled[2] >= self.period[2] then
			self.distanceTraveled[2] = self.distanceTraveled[2] - self.period[2]
			reset = true
		end
		if reset then
			self.image, self.follower = self.follower, self.image
			self.follower.x = self.image.x + self.period[1]*-1*fn.sign( self.velocity[1] )
			self.follower.y = self.image.y + self.period[2]*-1*fn.sign( self.velocity[2] )
		end
	end

	setmetatable( self, SceneryMT )
	return self
end

function Scenery.parallaxMinion( options )
	local self = {
		group = display.newGroup(),
		layer = options.layer,

		width = options.width,
		height = options.height,
		ratio = options.ratio,
		period = options.period,

		key = nil,

		distanceTraveled = { 0, 0 }
	}

	self.image = display.newImageRect( options.image, options.width, options.height )
	self.group:insert( self.image )
	self.image.x = options.xStart
	self.image.y = options.yStart

	self.follower = display.newImageRect( options.image, options.width, options.height )
	self.group:insert( self.follower)
	self.follower.x = options.xStart + options.period[1]
	self.follower.y = options.yStart + options.period[2]

	setmetatable( self, SceneryMT )
	return self
end

function Scenery.parallaxGroup( options )
	local self = {
		key = options.key,
		minions = options.minions
	}

	function self:place( zone )
		self.key:place( zone )
		for i, minion in ipairs( self.minions ) do
			minion:place( zone )
			minion.follower.x = minion.follower.x*-1*fn.sign( self.key.velocity[1] )
			minion.follower.y = minion.follower.y*-1*fn.sign( self.key.velocity[2] )
		end
	end

	function self:update( delta )
		local key = self.key
		key:update( delta )

		local step, reset
		for i, minion in ipairs( self.minions ) do
			step = { key.velocity[1]*minion.ratio*delta, key.velocity[2]*minion.ratio*delta }
			minion.image:translate( step[1], step[2] )
			minion.follower:translate( step[1], step[2] )
			minion.distanceTraveled = { minion.distanceTraveled[1]+abs( step[1] ), minion.distanceTraveled[2]+abs( step[2] ) }
		
			reset = false
			if minion.distanceTraveled[1] >= minion.period[1] then
				minion.distanceTraveled[1] = minion.distanceTraveled[1] - minion.period[1]
				reset = true
			end
			if minion.distanceTraveled[2] >= minion.period[2] then
				minion.distanceTraveled[2] = minion.distanceTraveled[2] - minion.period[2]
				reset = true
			end
			if reset then
				minion.image, minion.follower = minion.follower, minion.image
				minion.follower.x = minion.image.x + minion.period[1]*-1*fn.sign( minion.velocity[1] )
				minion.follower.y = minion.image.y + minion.period[2]*-1*fn.sign( minion.velocity[2] )
			end
		end
	end

	setmetatable( self, SceneryMT )
	return self
end

return Scenery