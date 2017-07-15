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

function PromptMachine:init( phase )
	self.index = 1
	self.prompt = self.script[ self.index ]
	self:enterPhase( "INIT" )
end

function PromptMachine:enterPhase( phase )
	self.prompt.phase = self.prompt.phases[ phase ]
	self.prompt.phase:enter( self.zone )
end

function PromptMachine:exitPhase( phase )
	self.prompt.phase:exit( self.zone )
end

function PromptMachine:advance()
	self.index = self.index+1
	if self.script[ self.index ] ~= nil then
		self.prompt = self.script[ self.index ]
		self.prompt.phase:enter( self.zone )
	elseif self.zone.states.COMPLETE ~= nil then
		self.zone:enterState( "COMPLETE" )
	end
end

return PromptMachine