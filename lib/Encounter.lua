--[[
		Setup
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "json"
local AI, DisplayManager = require "lib.AI", require "lib.DisplayManager"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Encounter Object
--]]
local Encounter = {}

-- EncounterState forward declarations
local EncounterIntroState, EncounterReadyState, EncounterPlayState, EncounterPauseState, EncounterCompleteState = {}, {}, {}, {}, {}

function Encounter.new( script, view )
	local self = {
		script = script,
		view = view,
		state = nil
	}

	self.ai = AI.new( self )
	self.dm = DisplayManager.new( self, view )

	self.INTRODUCTION = EncounterIntroState.new( self )
	self.READY = EncounterReadyState.new( self )
	self.PLAYING = EncounterPlayState.new( self )
	self.PAUSED = EncounterPauseState.new( self )
	self.COMPLETED = EncounterCompleteState.new( self )

	setmetatable( self, { __index = Encounter } )

	return self
end

function Encounter:enterState( state )
	if self.state.exitState ~= nil then self.state:exitState() end
	self.state = self[ state ]
	self.state:enter()
end

function Encounter:create( event ) self.state:create( event ) end
function Encounter:willShow( event ) self.state:willShow( event ) end
function Encounter:didShow( event ) self.state:didShow( event ) end
function Encounter:willHide( event ) self.state:willHide( event ) end
function Encounter:didHide( event ) self.state:didHide( event ) end
function Encounter:destroy( event ) self.state:destroy( event ) end

--[[
		EncounterState Objects
--]]

-- Base Encounter State
local EncounterState = {}

function EncounterState.new( encounter )
	local self = {
		encounter = encounter,
	}
	setmetatable( self, { __index = EncounterState } )
	return self
end

function EncounterState:enter() end

function EncounterState:create( event ) end
function EncounterState:willShow( event ) end
function EncounterState:didShow( event ) end
function EncounterState:willHide( event ) end
function EncounterState:didHide( event ) end
function EncounterState:destroy( event ) end

-- EncounterIntroState
setmetatable( EncounterIntroState, { __index = EncounterState } )

function EncounterIntroState.new( encounter )
	local self = EncounterState.new( encounter )

	setmetatable( self, { __index = EncounterIntroState } )
	return self
end

function EncounterIntroState:enter()
end

function EncounterIntroState:create( event )
end

function EncounterIntroState:willShow( event )
	composer.showOverlay( "scene.encounter_splash", {
		isModal = true, 
		params = self.encounter.script.getSplashScreenParameters()
	})
end