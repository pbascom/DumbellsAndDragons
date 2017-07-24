local data = {}

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
data.width = width; data.height = height
data.co = { xn, yn, xn - width/2 , yn - height/2, xn + width/2, yn + height/2 }
local tau = 2*math.pi

-- So weird that we need this. Don't worry, it'll be gone after testing.
local xn, yn, xo, yo, xf, yf = unpack( data.co )

data.sound = {
	bell = audio.loadSound( "assets/sound/bell.wav" ),
	applause = audio.loadSound( "assets/sound/applause.wav" )
}

data.speciesData = {}

data.speciesData.default = {
	acceleration = 240,
	maxSpeed = 120,
	maxAngularSpeed = tau/2,
	angularAcceleration = tau/4,
	precision = tau/4
}

data.speciesData.DragonChick = data.speciesData.default
data.speciesData.LegoDude = data.speciesData.default


--[[
		Zone Data
--]]
data.zoneData = {}

data.zoneData.classHall_ranger = {
	background = "assets/img/tavern_bg.png",
	regionData = {
		points = {
			floorTopLeft = { xn-15, yn+90 },
			floorTopRight = { xn+30, yn+90 },
			floorBottomLeft = { xn-140, yn+320 },
			floorBottomRight = { xn+100, yn+320 },
			tabletopLeft = { xn-112, yn+52 },
			tabletopRight = { xn-50, yn+52 },
			tabletopTop = { xn-80, yn+47 },
			tabletopBottom = { xn-80, yn+60 }
		},
		regions = {
			floor = {
				constructor = "intersection",
				args = {
					{ constructor = "below", args = { "floorTopLeft", "floorTopRight" } },
					{ constructor = "rightOf", args = { "floorTopLeft", "floorBottomLeft" } },
					{ constructor = "leftOf", args = { "floorTopRight", "floorBottomRight" } }
				}
			},
			tabletop = {
				constructor = "intersection",
				args = {
					{ constructor = "rightOf", args = { "tabletopLeft" } },
					{ constructor = "leftOf", args = { "tabletopRight" } },
					{ constructor = "above", args = { "tabletopBottom" } },
					{ constructor = "below", args = { "tabletopTop" } }
				}
			},
		}
	},
	actors = {
		george = { species = "legodude", role = "npc" },
		harold = { species = "legodude", role = "npc" },
		margery = { species = "legodude", role = "npc" }
	},
	patterns = {
		default = {
			george = { behavior = "idleInRegion", args = { "floor", "idle", "running" } },
			harold = { behavior = "standAtLocation", args = { "tabletop", "airSquats" } }
		}
	}
}

--[[
		Animation data
--]]
data.exerciseData = {
	airSquat = {
		base = "stand"
	},
	lunge = {
		base = "stand" -- eventually, change to standBack
	},
	highKnee = {
		base = "stand"
	},
	buttKick = {
		base = "stand"
	},
	karaoke = {
		base = "stand"
	},
	longJump = {
		base = "stand" -- Probably also change this to standBack
	},
	singleLegHop = {
		base = "stand",
		switchSides = 3
	},
	squatJump = {
		base = "stand"
	},
	flutterKick = {
		base = "supine",
	},
	plank = {
		base = "prone",
		transition = {
			into = "proneToPlank",
			outof = "plankToProne"
		}
	},
	birdDog = {
		base = "fours",
		switchSides = 1,
		transition = {
			into = "foursToBird",
			outof = "birdToFours"
		}
	},
	burpee = {
		base = "stand"
	},
	bicycle = {
		base = "supine",
		transition = {
			into = "standToSupine",
			outof = "supineToStand"
		}
	},
	mountainClimber = {
		base = "plank"
	},
	verticalLegLift = {
		base = "supine",
		transition = {
			into = "standToSupine",
			outof = "supineToStand"
		}
	}
}

return data