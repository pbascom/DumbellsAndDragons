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

-- States
local script = {
	-- Noncore 1, first set; intro
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore1

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Let's do this!" )
				zone.dm:setPrompt( self.exercise.prompt, "1 minute" )

				local animData = {}
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

				if type( sVars.noncore1.anim ) == "table" then
					a.hero:setAnimation( sVars.noncore1.anim[1], false )
					trackEntry = a.hero:addAnimation( sVars.noncore1.anim[2] )
					trackEntry.mixDuration = 0
				else
					a.hero:setAnimation( sVars.noncore1.anim )
				end

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
				if type( sVars.noncore1.anim ) == "table" then
					trackEntry.loop = false
					a.hero:addAnimation( "plankToStand", false )
					a.hero:addAnimation( "idle" )
				else
					a.hero:setAnimation( "idle" )
				end

				zone.ai:unregister( zone.dm.widget )
				zone.dm.widget:remove()
				zone.dm.widget = nil

				zone.pm:enterPhase( "CONCLUDE" )
			end
		}
	} ),
	-- Noncore 2, first set
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
	-- Noncore 2, second set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				self.exercise = sVars.noncore2

				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Time for " .. self.exercise.prompt .."!" )
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
	-- Noncore 1, third set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Last round of " ..sVars.noncore1.prompt .. "!" )
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
	-- Noncore 2, third set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Nice!" )
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
	-- Run, first set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Alright! Now take a lap." )
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
	-- Noncore 3, first set
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
	-- Noncore 4, first set
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Keep it moving now." )
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
	-- Run, second set
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
	-- Core 1, first set
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
	-- Core 2, first set
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
	-- Core 1, second set
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
	-- Core 2, second set
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
	-- Core 1, first set
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
	-- Core 2, third set; conclusion
	Prompt.new( {
		INIT = {
			enter = function( self, zone )
				zone.dm:setConfiguration( "init" )
				zone.dm:setFlavor( "Finish it." )
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

-- Zone
local zone = Zone.new( "id", p, r, a, s )


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