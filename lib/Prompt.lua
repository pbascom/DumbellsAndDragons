local data = require "lib.data"
local fn = require "lib.fn"

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

function Prompt.generate( zoneData, promptData )
	local p = zoneData.p -- points
	local r = zoneData.r -- regions
	local a = zoneData.a -- actors
	local e = zoneData.e -- environment / scenery

	local self = {
		exercise = promptData.exercise,
		exerciseData = data.exerciseData[ promptData.exercise.id ],
		duration = promptData.duration,
		isFirst = false,
		isFinal = false,
		state = nil
	}

	if promptData.isFirst == true then self.isFirst = true end
	if promptData.isFinal == true then self.isFinal = true end

	if promptData.flavor ~= nil then self.flavor = promptData.flavor
	else self.flavor = fn.getFlavor( exercise, self.isFirst, self.isFinal ) end

	if type( self.duration ) == "number" then
		if self.duration % 60 == 0 then
			self.durationText = ( self.duration / 60 ) .. " minutes"
		else
			self.durationText = self.duration .. " seconds"
		end
	else
		self.durationText = self.duration
	end

	-- States
	self.states = {
	INIT = {
		enter = function( zone )
			zone.dm:setConfiguration( "init" )
			zone.dm:setFlavor( self.flavor )
			zone.dm:setPrompt( self.exercise.prompt, self.durationText )

			if self.isFirst then
				zone.ai:place( a.hero, p.spawn )
				a.hero:setAnimation( self.exerciseData.base )
			end


		end
	},
	COMMIT = {},
	CONCLUDE = {}
	}

	self.state = INIT

	setmetatable( self, PromptMT )
	return self
end

return Prompt