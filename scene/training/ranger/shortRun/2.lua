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
--sVars.noncore2 = { id = "lunge", prompt = "Lunges", anim = "lunge" }
sVars.noncore3 = Exercises.new( "ranger", "noncore", 10, sVars )
sVars.noncore4 = Exercises.new( "ranger", "noncore", 10, sVars )
sVars.core1 = Exercises.new( "ranger", "core", 10, sVars )
sVars.core2 = Exercises.new( "ranger", "core", 10, sVars )

-- Script Object
local script = {
	-- Squats 1, intro
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore1

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Let's do this!" )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = data.animData[ self.exercise.anim ]
				if animData.displacement ~= nil then
					if animData.displacement == "right" then
						zone.ai:place( a.hero, p.stageLeft )
						a.hero.position = "left"
					elseif animData.displacement == "left" then
						zone.ai:place( a.hero, p.stageRight )
						a.hero.position = "right"
					end
				else
					zone.ai:place( a.hero, p.centerStage )
					a.hero.position = "center"
				end
				a.hero:setAnimation( "idle" )

				zone.playButton.callback = function()
					zone.pm:exitPhase( "INIT" )
				end
			end,
			exit = function( self, zone )
				zone.playButton.callback = nil
				audio.play( data.sound.bell )
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
	-- Lunges 1
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Nice job! Up next:" )
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
	-- Squats 2
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore1

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Back to squats now!" )
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
	-- Lunges 2
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Time for lunges!" )
				zone.dm:setPrompt( sVars.noncore2.prompt, "1 minute" )

				-- WalkTo
				zone.ai:place( a.hero, p.stageLeft )

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
	-- Squats 3
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Last Round!" )
				zone.dm:setPrompt( sVars.noncore1.prompt, "1 minute" )

				zone.ai:place( a.hero, p.centerStage )
				a.hero:setAnimation( "idle" )

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
	-- Lunges 3
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Alright! Almost there." )
				zone.dm:setPrompt( sVars.noncore2.prompt, "1 minute" )

				-- WalkTo
				zone.ai:place( a.hero, p.stageLeft )

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
	-- Run 1
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Nice! Now take a lap." )
				zone.dm:setPrompt( "Run", "1 mile" )

				zone.ai:place( a.hero, p.stageLeft )

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
	-- High Knees
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "It's not over yet!" )
				zone.dm:setPrompt( sVars.noncore3.prompt, "1 minute" )

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

				a.hero:setAnimation( sVars.noncore3.anim )
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
	-- Butt Kicks
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "I told you to bring shoes!" )
				zone.dm:setPrompt( sVars.noncore4.prompt, "1 minute" )

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

				a.hero:setAnimation( sVars.noncore4.anim )
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
	-- Run 2
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Perfect! Another lap." )
				zone.dm:setPrompt( "Run", "1 mile" )

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
					audio.play( data.sound.applause )
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
	-- Burpees 1
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Time to \"cool down.\"" )
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
	-- Bird Dogs 1
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Train that core, Ranger!" )
				zone.dm:setPrompt( sVars.core2.prompt, "1 minute" )

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
	-- Burpees 2
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Back to burpees!" )
				zone.dm:setPrompt( sVars.core1.prompt, "1 minute" )

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
	-- Bird Dogs 2
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Almost there, now..." )
				zone.dm:setPrompt( sVars.core2.prompt, "1 minute" )

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
	-- Burpees 3
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Last round!" )
				zone.dm:setPrompt( sVars.core1.prompt, "1 minute" )

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
	-- Bird Dogs 2
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Finish it!" )
				zone.dm:setPrompt( sVars.core2.prompt, "1 minute" )

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
	} )
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