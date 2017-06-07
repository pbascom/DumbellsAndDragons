local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Action, Behavior = require "lib.Region", require "lib.Action", require "lib.Behavior"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Actor Object definitions
--]]
local Actor = {}
local ActorMT = { __index = Actor }

function Actor.new( species, location )
	local spineData = fn.loadSpineObject( species, 0.25 )
	local self = {
		skeleton = spineData.skeleton,
		group = spineData.skeleton.group,
		animationState = spineData.animationState,
		action = nil,
		behavior = nil
	}

	self.group.x = location[1]
	self.group.y = location[2]

	-- Track 1 is idle. 2 is animation, 3 is misc, 4 is adjustment.
	self.animationState:setAnimationByName( 1, "idle", true )

	setmetatable( self, ActorMT )
	return self
end

function Actor:act( delta )
	self.animationState:update( delta )
	self.animationState:apply( self.skeleton )
	self.skeleton:updateWorldTransform()
	if self.action ~= nil then
		self.action:update( delta )
	end
end

-- Animation control methods
function Actor:setIdle( idle )
	if idle ~= nil then
		self.animationState:setAnimationByName( 1, idle, true )
	else
		self.animationState:setEmptyAnimation( 1 )
	end
end

function Actor:setAnimation( animation, loop, opacity )
	if opacity == nil then opacity = 1 end
	if animation ~= nil then
		self.animationState:setAnimationByName( 2, animation, false or loop, opacity )
	else
		self.animationState:setEmptyAnimation( 2 )
	end
end

function Actor:setAdjustment( adjustment, opacity )
	if adjustment ~= nil then
		self.animationState:setAnimationByName( 4, adjustment, true, opacity )
	else
		self.animationState:setEmptyAnimation( 4 )
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

function Actor:moveToPoint( location, speed, easing )
	self:setAction( Action.moveToPoint( self, location, speed, easing ) )
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