local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Action, Behavior = require "lib.Region", require "lib.Action", require "lib.Behavior"
local xn, yn, xo, yo, xf, yf = unpack( data.co )
local tau = 2*math.pi

--[[
		Actor Object definitions
--]]
local Actor = {}
local ActorMT = { __index = Actor }

function Actor.new( species, roles )
	local spineData = fn.loadSpineObject( species, 0.2 )
	local self = {
		species = species,
		roles = {},
		skeleton = spineData.skeleton,
		group = spineData.skeleton.group,
		animationState = spineData.animationState,
		action = nil,
		behavior = nil,
		movement = nil,

		steering = {
			position = spineData.skeleton.group,
			speed = 0,
			maxSpeed = data.speciesData[species].maxSpeed,
			acceleration = data.speciesData[species].acceleration,
			orientation = tau/4,
			aim = tau/4,
			precision = data.speciesData[species].precision,
			angularSpeed = 0,
			maxAngularSpeed = data.speciesData[species].maxAngularSpeed,
			angularAcceleration = data.speciesData[species].angularAcceleration
		}
	}

	-- Populate Roles table
	if roles ~= nil then
		for i, value in ipairs( roles ) do
			self.roles[ value ] = true
		end
	end

	-- Actors start inactive
	self.group.isVisible = false

	setmetatable( self, ActorMT )
	return self
end

function Actor:update( delta )
	self.animationState:update( delta )
	self.animationState:apply( self.skeleton )
	self.skeleton:updateWorldTransform()
	if self.action ~= nil then
		self.action:update( delta )
	end
	if self.movement ~= nil then
		self.movement:update( delta )
	end
end

-- Role management methods
function Actor:hasRole( role )
	return self.roles[ role ] ~= nil
end

function Actor:addRole( role )
	self.roles[ role ] = true
end

function Actor:removeRole( role )
	if self.roles[ role ] ~= nil then self.roles[ role ] = nil end
end

-- Animation control methods
function Actor:setAnimation( animation, loop, opacity )
	if opacity == nil then opacity = 1 end
	if loop == nil then loop = true end

	local trackEntry
	if animation == "empty" then
		trackEntry = self.animationState:setEmptyAnimation( 1 )
	else
		trackEntry = self.animationState:setAnimationByName( 1, animation, loop, opacity )
	end
	return trackEntry
end

function Actor:addAnimation( animation, loop, opacity )
	if opacity == nil then opacity = 1 end
	if loop == nil then loop = true end
	print( animation )
	local trackEntry = self.animationState:addAnimationByName( 1, animation, loop, opacity )
	return trackEntry
end

function Actor:setAdjustment( adjustment, opacity )
	if adjustment ~= nil then
		self.animationState:setAnimationByName( 2, adjustment, true, opacity )
	else
		self.animationState:setEmptyAnimation( 2 )
	end
end

function Actor:face( direction )
	if direction == "left" then
		self.group.xScale = -1
	else
		self.group.xScale = 1
	end
end

-- Action control methods
function Actor:setAction( action )
	self.action = action
end

function Actor:moveToPoint( location, animation )
	if animation ~= nil then
		print( "moveToPoint: " .. animation )
		self:setAction( Action.moveToPoint( self, location, animation ) )
	else
		self:setAction( Action.moveToPoint( self, location ) )
	end
end

-- Behavior control methods
function Actor:setBehavior( behavior )
	self.behavior = behavior
	self:checkBehavior( { "init" } )
end

function Actor:checkBehavior( reasons )
	if self.behavior ~= nil then
		self.behavior:check( reasons )
	elseif reasons[1] == "actionComplete" then
		self.action = nil
	end
end

function Actor:wander( region, speed )
	self:setBehavior( Behavior.wander( self, region, speed ) )
end

return Actor