local Prompt = {}
local PromptMT = { __index = Prompt }

function Prompt:enterPhase( phase )
	if self.phases[ phase ] ~= nil then
		self.phase = self.phases[ phase ]
		self.phase:enter( zone )
	end
end

function Prompt.new( phases )
	local self = {
		phases = {},
		phase = nil
	}

	self.phases = {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:displayPrompt( "New", "Prompt" )
				zone.dm:setFlavor( "Awwwww Yeeeaaaah." )
				zone.playButton.callback = function()
					self:exit( zone )
				end
			end,
			exit = function( self, zone )
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
			end,
			exit = function( self, zone )
				zone.pm:enterPhase( "CONCLUDE" )
			end
		},
		CONCLUDE = {
			enter = function( self, zone )
				self:exit( zone )
			end,
			exit = function( self, zone )
				zone.pm:advance()
			end
		}
	}
	if phases ~= nil then
		for phase, functions in pairs( phases ) do
			for key, value in pairs( functions ) do
				self.phases[ phase ][ key ] = value
			end
		end
	end
	self.phase = self.phases[ "INIT" ]

	setmetatable( self, PromptMT )
	return self
end

return Prompt