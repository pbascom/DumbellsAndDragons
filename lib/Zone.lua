local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local AI, Actor = require "lib.AI", require "lib.Actor"
local DisplayManager, PromptMachine = require "lib.DisplayManager", require "lib.PromptMachine"
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

function Zone.new( id, points, regions, actors, environment, states, script )
	local self = {
		id = id,
		points = points,
		regions = regions,
		actors = actors,
		environment = environment,
		script = script,

		states = states,
		state = {},
	}
	setmetatable( self, { __index = Zone } )
	setmetatable( actors, { __index = fn.betterTables } )

	return self
end

function Zone:init( scene, event )
	self.ai = AI.new( self, self.actors )

	-- Display Groups
	self.view = scene.view

	self.background = display.newGroup()
	self.view:insert( self.background )

	self.parallaxFar = display.newGroup()
	self.view:insert( self.parallaxFar )

	self.parallaxMid = display.newGroup()
	self.view:insert( self.parallaxMid )

	self.midground = display.newGroup()
	self.view:insert( self.midground )

	self.parallaxNear = display.newGroup()
	self.view:insert( self.parallaxNear )

	self.foreground = display.newGroup()
	self.view:insert( self.foreground )

	self.parallaxFront = display.newGroup()
	self.view:insert( self.parallaxFront )

	self.parallaxForemost = display.newGroup()
	self.view:insert( self.parallaxForemost )

	self.interface = display.newGroup()
	self.view:insert( self.interface )

	-- Display Manager
	self.dm = DisplayManager.new( self.interface )
	self.playButton, self.pauseButton = self.dm:build()

	-- Prompt Machine
	self.pm = PromptMachine.new( self, self.script )
	
	-- Background image
	local background = display.newImageRect( "assets/img/" .. self.id .. "_background.jpg", theme.fullWidth, theme.fullHeight )
	self.background:insert( background ); background.x = xn; background.y = yn

	-- Environment placement
	for key, object in pairs( self.environment ) do
		object:place( self )
	end

	if self.states.DEFAULT ~= nil then self:enterState( "DEFAULT" ) end
	print( "Zone.init" )
end

return Zone