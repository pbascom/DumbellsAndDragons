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

	function self:act( delta )
		self.animationState:update( delta/1000 )
		self.animationState:apply( self.skeleton )
		self.skeleton:updateWorldTransform()
		if self.action ~= nil then
			self.action:update( delta )
		end

	end

	function self:checkBehavior( reasons )
		if self.behavior ~= nil then
			self.behavior:check( reasons )
		elseif reasons[1] == "actionComplete" then
			self.action = nil
		end
	end

	-- Animation control methods
	function self:setAnimation( animation, loop )
		self.animationState:setAnimationByName(0, animation, false or loop )
	end

	-- Action control methods
	function self:setAction( action )
		self.action = action
	end

	function self:moveToPoint( location, speed, easing )
		print( "action set: moveToPoint" )
		self:setAction( Action.moveToPoint( self, location, speed, easing ) )
	end

	-- Behavior control methods
	function self:setBehavior( behavior )
		self.behavior = behavior
		self:checkBehavior( { "init" } )
	end

	function self:wander( region, speed )
		self:setBehavior( Behavior.wander( self, region, speed ) )
	end

	

	

	setmetatable( self, ActorMT )
	return self
end

return Actor