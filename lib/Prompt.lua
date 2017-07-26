local data = require "lib.data"
local fn = require "lib.fn"
local Widget = require "lib.Widget"

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
		hasCommands = false,
		state = nil
	}

	if promptData.isFirst == true then self.isFirst = true end
	if promptData.isFinal == true then self.isFinal = true end

	if promptData.commands ~= nil then
		self.hasCommands = true
		self.commands = promptData.commands
	end

	if promptData.flavor ~= nil then self.flavor = promptData.flavor
	else self.flavor = fn.getFlavor( self.exercise, self.isFirst, self.isFinal ) end

	if type( self.duration ) == "number" then
		if self.duration % 60 == 0 then
			if self.duration / 60 == 1 then self.durationText = "1 minute"
			else self.durationText = ( self.duration / 60 ) .. " minutes" end
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
					a.hero:setBaseAnimation( self.exerciseData.base )
				elseif self.exerciseData.base ~= a.hero.baseAnimation then
					a.hero:changeBaseAnimation( self.exerciseData.base )
				end

				zone.playButton.callback = function()
					zone.pm:exitState( "INIT" )
				end

				if self.hasCommands then
					if self.commands.init ~= nil then self.commands.init( zone ) end
				end
			end,
			exit = function( zone )
				zone.playButton.callback = nil
				audio.play( data.sound.bell )
				zone.pm:enterState( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( zone )
				zone.dm:setConfiguration( "active" )
				if type( self.duration ) == "number" then
					zone.playButton.isVisible = false
				end

				if self.exerciseData.transition ~= nil then
					a.hero:setAnimation( self.exerciseData.transition.into, false )
					a.hero:addAnimation( self.exercise.anim )
				else
					a.hero:setAnimation( self.exercise.anim )
				end

				if type( self.duration ) == "number" then
					zone.dm.widget = Widget.countdown( {
						duration = self.duration,
						group = zone.interface,
						callback = function()
							audio.play( data.sound.applause )
							zone.pm:exitState( "COMMIT" )
						end
					} )
					zone.ai:register( zone.dm.widget )
				else
					zone.playButton.callback = function()
						zone.pm:exitState( "COMMIT" )
					end
				end

				if self.hasCommands then
					if self.commands.commit ~= nil then self.commands.commit( zone ) end
				end
			end,
			exit = function( zone )
				if self.exerciseData.transition ~= nil then
					a.hero.currentTrackEntry.loop = nil
					a.hero:addAnimation( self.exerciseData.transition.outof, false )
					a.hero:addAnimation( self.exerciseData.base )
				else
					a.hero:setAnimation( self.exerciseData.base )
				end

				if zone.dm.widget ~= nil then
					zone.ai:unregister( zone.dm.widget )
					zone.dm.widget:remove()
					zone.dm.widget = nil
				end

				zone.pm:enterState( "CONCLUDE" )
			end
		},
		CONCLUDE = {
			enter = function( zone )
		
				if self.hasCommands then
					if self.commands.conclude ~= nil then self.commands.conclude( zone ) end
				end

				zone.pm:exitState( "CONCLUDE" )
			end,
			exit = function( zone )
				zone.pm:advance()
			end
		}
	}

	self.state = self.states.INIT

	setmetatable( self, PromptMT )
	return self
end

return Prompt