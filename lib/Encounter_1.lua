local AI = require "lib.AI"
local DisplayManager = require "lib.DisplayManager"

local Encounter = {}

local EncounterState = {}

function EncounterState.new( encounter, script )
	local self = {
		encounter = encounter,
		script = script
	}
	setmetatable( self, { __index = EncounterState } )

	return self
end

local EncounterIntroState = {}
setmetatable( EncounterIntroState, { __index = EncounterState } )

function EncounterIntroState.new( encounter, script )
	local self = EncounterState.new( encounter, script )
	setmetatable( self, { __index = EncounterIntroState } )
	return self
end

function EncounterIntroState:enter()
	local splashOptions = self.script.splashOptions
	local instructions = self.state.
end

function Encounter.new( script )
	local self = {
		script = script,
		ai = AI.new(),
		dm = DisplayManager.new(),

		state = nil,
		INTRO = EncounterIntroState.new( self, script ),
		READY = EncounterReadyState.new( self, script ),
		PLAY  = EncounterPlayState.new(  self, script ),
		PAUSE = EncounterPauseState.new( self, script ),
		DONE  = EncounterDoneState.new(  self, script )
	}
	setmetatable( self, { __index = Encounter } )

	return self
end

function Encounter:enterState( state )
	self.state = self[ state ]
	self.state.enter()
end

return Encounter