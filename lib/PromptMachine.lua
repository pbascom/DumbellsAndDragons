local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Prompt = require "lib.Prompt"

local PromptMachine = {}
local PromptMachineMT = { __index = PromptMachine }

function PromptMachine.new( zone, script )
	local self = {
		zone = zone,
		script = script,
		index = 1,
		prompt = nil
	}

	self.prompt = self.script[ self.index ]

	setmetatable( self, PromptMachineMT )
	return self
end

function PromptMachine:init( state )
	self.index = 1
	self.prompt = self.script[ self.index ]
	self:enterState( "INIT" )
end

function PromptMachine:enterState( state )
	self.prompt.state = self.prompt.states[ state ]
	self.prompt.state:enter( self.zone )
end

function PromptMachine:exitState( state )
	self.prompt.state:exit( self.zone )
end

function PromptMachine:advance()
	self.index = self.index+1
	if self.script[ self.index ] ~= nil then
		self.prompt = self.script[ self.index ]
		self.prompt.state:enter( self.zone )
	elseif self.zone.states.COMPLETE ~= nil then
		self.zone:enterState( "COMPLETE" )
	end
end

return PromptMachine