local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local Region, AI, Actor = require "lib.region", require "lib.AI", require "lib.Actor"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local Zone = {}

function Zone:create( scene, event )
	self:init( scene, event )
	if self.state.create ~= nil then
		self.state:create( self, event )
	end
end

function Zone:willShow( event )
	if self.state.willShow ~= nil then
		self.state:willShow( self, event )
	end
end

function Zone:didShow( event )
	if self.state.didShow ~= nil then
		self.state:didShow( self, event )
	end
end

function Zone:willHide( event )
	if self.state.willHide ~= nil then
		self.state:willHide( self, event )
	end
end

function Zone:didHide( event )
	if self.state.didHide ~= nil then
		self.state:didHide( self, event )
	end
end

function Zone:destroy( event )
	if self.state.destroy ~= nil then
		self.state:destroy( self, event )
	end
end

function Zone:enterState( state )
	if self.states[state] ~= nil then
		print( "Attempting to enter state " .. state )
		self.state = self.states[state]
		self.state:enter( self )
	end
end

function Zone.new( id, points, regions, actors, states )
	local self = {
		id = id,
		points = points,
		regions = regions,
		actors = actors,

		states = states,
		state = {},

		ai = AI.new( self, actors )
	}
	setmetatable( self, { __index = Zone } )
	setmetatable( actors, { __index = fn.betterTables } )

	return self
end

function Zone:init( scene, event )
	self.view = scene.view

	self.background = display.newGroup()
	self.view:insert( self.background )

	self.midground = display.newGroup()
	self.view:insert( self.midground )

	self.foreground = display.newGroup()
	self.view:insert( self.foreground )

	self.interface = display.newGroup()
	self.view:insert( self.interface )
	
	local background = display.newImageRect( "assets/img/" .. self.id .. "_bg.png", theme.fullWidth, theme.fullHeight )
	self.background:insert( background ); background.x = xn; background.y = yn

	if self.states.DEFAULT ~= nil then self:enterState( "DEFAULT" ) end
	print( "Zone.init" )
end

return Zone