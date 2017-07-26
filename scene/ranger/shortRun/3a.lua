local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer = require "composer"
local Zone, Region, Actor, Prompt = require "lib.Zone", require "lib.Region", require "lib.Actor", require "lib.Prompt"
local Action, Behavior, Scenery = require "lib.Action", require "lib.Behavior", require "lib.Scenery"
local Widget, Exercises = require "lib.Widget", require "lib.Exercises"
local DisplayManager, PromptMachine = require "lib.DisplayManager", require "lib.PromptMachine"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Zone object creation
--]]
-- Points
local p = {
	centerStage = { x = xn, y = yf-80 },
	stageLeft = { x = xo+80, y = yf-80 },
	stageRight = { x = xf-80, y = yf-80 }
}

-- Regions
local r = {}

-- Actors
local a = {
	hero = Actor.new( "DragonChick", { "avatar" } )
}

--[[
		Script Creation
--]]

-- Script Variables
local sVars = {}
sVars.noncore1 = Exercises.new( "ranger", "noncore", 10, sVars )
sVars.noncore2 = Exercises.new( "ranger", "noncore", 10, sVars )
sVars.core1 = Exercises.new( "ranger", "core", 10, sVars )
sVars.core2 = Exercises.new( "ranger", "core", 10, sVars )

-- Script Object
local script = {
	--Noncore1, first set; Intro
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore1

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Alright! Let's get this started." )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" then
						zone.ai:place( a.hero, p.stageLeft )
						a.hero.position = "left"
					elseif animData.displacement == "left" then
						zone.ai:place( a.hero, p.stageRight )
						a.hero.position = "right"
					else
						zone.ai:place( a.hero, p.centerStage)
						a.hero.position = "center"
					end
				else
					zone.ai:place( a.hero, p.centerStage)
					a.hero.position = "center"
				end

				-- Countdown
				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.noncore1.anim )
				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	--Core 1, first set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Brilliant! Keep it going." )
				zone.dm:setPrompt( sVars.core1.prompt, "1 minute" )

				zone.ai:place( a.hero, p.centerStage )

				-- Countdown
				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.core1.anim )
				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Noncore 1, second set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore1

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Back to " .. self.exercise.prompt .. " now!" )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.noncore1.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	--Core 1, second set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Awesome! Keep it going." )
				zone.dm:setPrompt( sVars.core1.prompt, "1 minute" )

				zone.ai:place( a.hero, p.centerStage )

				-- Countdown
				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.core1.anim )
				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Noncore 1, third set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore1

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Last round of " .. self.exercise.prompt .. "!" )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.noncore1.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	--Core 1, third set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Great! Keep it moving." )
				zone.dm:setPrompt( sVars.core1.prompt, "1 minute" )

				zone.ai:place( a.hero, p.centerStage )

				-- Countdown
				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.core1.anim )
				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Run
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Alright! You ready for a run?" )
				zone.dm:setPrompt( "Run", "2 miles" ) -- 1000 meters

				if a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				-- Countdown
				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )

				a.hero:setAnimation( "run" )
				a.hero:moveToPoint( p.centerStage )

				zone.ai:register( zone.scenery.parallaxBackground )
				zone.ai:register( zone.scenery.parallaxMidground  )
				zone.ai:register( zone.scenery.parallaxForeground )
				zone.ai:register( zone.scenery.parallaxForefront  )

				zone.playButton.callback = function()
					zone.pm:exitPhase( "COMMIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "CONCLUDE" )
			end
		},
		CONCLUDE = {
			enter = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.scenery.parallaxBackground )
				zone.ai:unregister( zone.scenery.parallaxMidground  )
				zone.ai:unregister( zone.scenery.parallaxForeground )
				zone.ai:unregister( zone.scenery.parallaxForefront  )

				zone.pm:exitPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Noncore 2, first set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Welcome back! Let's switch this up." )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.noncore2.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Core 2, first set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.core2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Up next:" )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.core2.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Noncore 2, second set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Just a few more rounds..." )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.noncore2.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Core 2, second set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.core2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Keep it going!" )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.core2.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Noncore 2, third set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Almost done! Just keep going." )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.noncore2.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Core 2, third set; Conclusion
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.core2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "This is it! Finish strong." )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" and a.hero.position ~= "left" then
						a.hero:moveToPoint( p.stageLeft, "run" )
						a.hero.position = "left"
					elseif animData.displacement == "left" and a.hero.postion ~= "right" then
						a.hero:moveToPoint( p.stageRight, "run" )
						a.hero.position = "right"
					end
				elseif a.hero.position ~= "center" then
					a.hero:moveToPoint( p.centerStage, "run" )
					a.hero.position = "center"
				end

				zone.playButton.callback = function()
					audio.play( data.sound.bell )
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				zone.pm:enterPhase( "COMMIT" )
			end
		},
		COMMIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "active" )
				zone.playButton.isVisible = false

				a.hero:setAnimation( sVars.core2.anim )

				zone.dm.widget = Widget.countdown( {
					duration = 60,
					group = zone.interface,
					callback = function()
						audio.play( data.sound.applause )
						zone.pm:exitPhase( "COMMIT" )
					end
				} )
				zone.ai:register( zone.dm.widget )
			end,
			exit = function( self, zone )
				a.hero:setAnimation( "idle" )

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
}

-- States
local s = {
	DEFAULT = {
		enter = function( self, zone )
			local a = zone.actors
			zone.ai:activate( a.hero )

			zone.scenery = {
				parallaxBackground = Scenery.endlessParallax( {
					layer = zone.background,
					width = 1086,
					height = 640,
					xStart = xn,
					yStart = yn,
					velocity = { -10, 0 },
					period = { 1086, 640 },
					image = "assets/img/training_forest_parallax_background.png"
				} ),
				parallaxMidground = Scenery.endlessParallax( {
					layer = zone.midground,
					width = 1086,
					height = 640,
					xStart = xn,
					yStart = yn,
					velocity = { -20, 0 },
					period = { 1086, 640 },
					image = "assets/img/training_forest_parallax_midground.png"
				} ),
				parallaxForeground = Scenery.endlessParallax( {
					layer = zone.foreground,
					width = 1086,
					height = 640,
					xStart = xn,
					yStart = yn,
					velocity = { -80, 0 },
					period = { 1086, 640 },
					image = "assets/img/training_forest_clearing.png"
				} ),
			}

			zone.midground:insert( a.hero.group )

			zone.forefront = display.newGroup()
			zone.view:insert( zone.forefront )
			zone.view:insert( zone.interface )

			zone.scenery.parallaxForefront = Scenery.endlessParallax( {
				layer = zone.forefront,
				width = 1086,
				height = 640,
				xStart = xn+2080,
				yStart = yn,
				velocity = { -120, 0 },
				period = { 3660, 640 },
				image = "assets/img/training_forest_parallax_front.png"
			} )

			zone.dm = DisplayManager.new( zone.interface )
			zone.playButton, zone.pauseButton = zone.dm:build()

			zone.pm = PromptMachine.new( zone, script )
		end,
		didShow = function( self, zone, event )
			composer.showOverlay( "scene.welcomeScreen", { params = { parentZone = zone } } )
			-- zone:enterState( "ACTIVE" )	
		end
	},
	ACTIVE = {
		enter = function( self, zone )
			system.setIdleTimer( false )
			zone.pm:init()
		end
	},
	COMPLETE = {
		enter = function( self, zone )
			system.setIdleTimer( true )
			composer.showOverlay( "scene.thankYouScreen", { params = { parentZone = zone } } )
		end
	}
}

-- Zone
local zone = Zone.new( "training_forest", p, r, a, s )


--[[
		Scene object creation
--]]
local scene = composer.newScene()

function scene:create( event )
	zone:create( self, event )
end

function scene:show( event )
	if event.phase == "will" then
		zone:willShow( event )
	elseif event.phase == "did" then
		zone:didShow( event )
	end
end

function scene:hide( event )
	if event.phase == "will" then
		zone:willHide( event )
	elseif event.phase == "did" then
		zone:didShow( event )
	end
end

function scene:destroy( event )
	zone:destroy( event )
end


--[[
		Listeners & Runtime Integration
--]]
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene