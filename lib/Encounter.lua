--[[
		Setup
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local AI, DisplayManager, Script = require "lib.AI", require "lib.DisplayManager", require "lib.Script"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Encounter Object
--]]
local Encounter = {}

-- EncounterState forward declarations
local EncounterIntroState, EncounterReadyState, EncounterPlayState, EncounterPauseState, EncounterCompleteState = {}, {}, {}, {}, {}

function Encounter.new( view, params )
	local self = {
		view = view,
		state = nil,

		background = display.newGroup(),
		midground  = display.newGroup(),
		foreground = display.newGroup(),
		interface  = display.newGroup()
	}

	view:insert( self.background )
	view:insert( self.midground  )
	view:insert( self.foreground )
	view:insert( self.interface  )

	self.ai = AI.new( self )
	self.dm = DisplayManager.new( self.interface )
	self.script = Script.new( ai, dm, params )

	self.INTRO = EncounterIntroState.new( self )
	self.READY = EncounterReadyState.new( self )
	self.PLAY = EncounterPlayState.new( self )
	self.PAUSE = EncounterPauseState.new( self )
	self.COMPLETE = EncounterCompleteState.new( self )

	setmetatable( self, { __index = Encounter } )

	return self
end

function Encounter:enterState( state )
	if self.state ~= nil and self.state.exitState ~= nil then self.state:exitState() end
	self.state = self[ state ]
	self.state:enter()
end

function Encounter:play( event )
	if self.state ~= nil and self.state.play ~= nil then
		self.state:play( event )
	end
end

function Encounter:pause( event )
	if self.state ~= nil and self.state.pause ~= nil  then
		self.state:play( event )
	end
end

function Encounter:create( event ) if self.state ~= nil then self.state:create( event ) end end
function Encounter:willShow( event ) if self.state ~= nil then self.state:willShow( event ) end end
function Encounter:didShow( event ) if self.state ~= nil then self.state:didShow( event ) end end
function Encounter:willHide( event ) if self.state ~= nil then self.state:willHide( event ) end end
function Encounter:didHide( event ) if self.state ~= nil then self.state:didHide( event ) end end
function Encounter:destroy( event ) if self.state ~= nil then self.state:destroy( event ) end end

--[[
		EncounterState Objects
--]]

-- Base Encounter State
local EncounterState = {}

function EncounterState.new( encounter )
	local self = {
		encounter = encounter,
		script = encounter.script,
		ai = encounter.ai,
		dm = encounter.dm
	}
	setmetatable( self, { __index = EncounterState } )
	return self
end

function EncounterState:enter() end
function EncounterState:play( event ) end
function EncounterState:pause( event ) end

function EncounterState:create( event ) end
function EncounterState:willShow( event ) end
function EncounterState:didShow( event ) end
function EncounterState:willHide( event ) end
function EncounterState:didHide( event ) end
function EncounterState:destroy( event ) end

-- Encounter Intro State
setmetatable( EncounterIntroState, { __index = EncounterState } )

function EncounterIntroState.new( encounter )
	local self = EncounterState.new( encounter )

	setmetatable( self, { __index = EncounterIntroState } )
	return self
end

function EncounterIntroState:enter()
	local info = self.script:getInfo()
	composer.showOverlay( "scene.encounter_splash", { isModal = true, params = {
		id = info.id,
		description = info.description,
		duration = info.duration,
		equipment = info.equipment,
		encounter = self.encounter
	} } )
end

function EncounterIntroState:create( event )
	local info = self.script:getInfo()
	self.wallpaper = display.newImageRect( "assets/img/" .. info.id .. "_bg.png", theme.fullWidth, theme.fullHeight )
	self.encounter.background:insert( self.wallpaper )
	self.wallpaper.x = xn; self.wallpaper.y = yn

	self.script:loadAssets()
	local playButton, pauseButton = self.dm:build()
	function playButton.callback( event ) self.encounter:play( event ) end
	function pauseButton.callback( event ) self.encounter:pause( event ) end
end

function EncounterIntroState:willShow( event )
	self.script:prepare( self.ai, self.dm )
end

-- Encounter Ready State
setmetatable( EncounterReadyState, { __index = EncounterState } )

function EncounterReadyState.new( encounter )
	local self = EncounterState.new( encounter )

	setmetatable( self, { __index = EncounterReadyState } )
	return self
end

function EncounterReadyState:enter()
	self.script:getReady()
end

-- Encounter Play State
setmetatable( EncounterPlayState, { __index = EncounterState } )

function EncounterPlayState.new( encounter )
	local self = EncounterState.new( encounter )

	setmetatable( self, { __index = EncounterPlayState } )
	return self
end

-- Encounter Pause State
setmetatable( EncounterPauseState, { __index = EncounterState } )

function EncounterPauseState.new( encounter )
	local self = EncounterState.new( encounter )

	setmetatable( self, { __index = EncounterPauseState } )
	return self
end

-- Encounter Complete State
setmetatable( EncounterCompleteState, { __index = EncounterState } )

function EncounterCompleteState.new( encounter )
	local self = EncounterState.new( encounter )

	setmetatable( self, { __index = EncounterCompleteState } )
	return self
end

return Encounter