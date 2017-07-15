local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region = require "lib.Region"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local abs = math.abs
local tau = 2*math.pi

local Scenery = {}
local SceneryMT = { __index = Scenery }

function Scenery.endlessParallax( options )
	local self = {
		width = options.width,
		height = options.height,
		velocity = options.velocity,
		period = options.period,

		width = options.width,
		height = options.height,

		distanceTraveled = { 0, 0 }
	}

	self.image = display.newImageRect( options.image, options.width, options.height )
	options.layer:insert( self.image )
	self.image.x = options.xStart
	self.image.y = options.yStart

	self.follower = display.newImageRect( options.image, options.width, options.height )
	options.layer:insert( self.follower)
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

function Scenery.parallaxObject( options )
	local self = {
		width = options.width,
		height = options.height,
		period = options.period,

		distanceTraveled = { 0, 0 }
	}

	if options.velocity ~= nil then self.velocity = options.velocity end
	if options.speedRatio ~= nil then self.speedRatio = options.speedRatio end

	self.image = display.newImageRect( options.image, options.width, options.height )
	options.layer:insert( self.image )
	self.image.x = options.xStart
	self.image.y = options.yStart

	self.follower = display.newImageRect( options.image, options.width, options.height )
	options.layer:insert( self.follower)
	self.follower.x = options.xStart + options.period[1]*-1*fn.sign( self.velocity[1] )
	self.follower.y = options.yStart + options.period[2]*-1*fn.sign( self.velocity[2] )

	function self:update( delta )
		if self.velocity == nil then self.velocity = { 10, 0 } end

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

	function self:keyOff( disp )
		if self.speedRatio == nil then self.speedRatio = 1 end

		local step = { self.speedRatio*disp[1], self.speedRatio*disp[2] }
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

function Scenery.parallaxGroup( options )
	local self = {
		key = options.key,
		members = options.members,

		movement = nil,
		distanceTraveled = { 0, 0 }
	}

	-- Note: the key object must be assigned a steering object for this to work. Alternatively,
	-- we can make the parallaxGroup itself the key object, with the group to be translated.

	function self:update( delta )
		local keyDisp = self.key.movement:update()
		for key, member in pairs( self.members ) do
			member:keyOff( keyDisp )
		end
	end

	setmetatable( self, SceneryMT )
	return self
end

return Scenery