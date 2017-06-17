local data = {}

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
data.width = width; data.height = height
data.co = { xn, yn, xn - width/2 , yn - height/2, xn + width/2, yn + height/2 }
local tau = 2*math.pi

-- So weird that we need this. Don't worry, it'll be gone after testing.
local xn, yn, xo, yo, xf, yf = unpack( data.co )

-- Sample json information (parsed)
data.sampleRegionData = {
points = {
		baseOfStairs = { xn-120, yn+240 },
		rocks = { xn+90, yn+260 },
		stairsBottomLeft = { xn-160, yn+230 },
		stairsBottomRight = { xn-60, yn+240 },
		stairsTopLeft = { xn+120, yn+22 },
		stairsTopRight = { xn+124, yn+65 },
		offScreenLeft = { xn-140, yo - 40 },
	},
	regions = {
		belowStairs = {
			constructor = "intersection",
			args = {
				{ constructor = "below", args = { "baseOfStairs", "rocks" } }
			}
		},
		stairs = {
			constructor = "intersection",
			args = {
				{ constructor = "above", args = { "stairsBottomLeft", "stairsBottomRight" } },
				{ constructor = "leftOf", args = { "stairsBottomRight", "stairsTopRight" } },
				{ constructor = "rightOf", args = { "stairsBottomLeft", "stairsTopLeft" } }
			}
		},
		roamZone = {
			constructor = "union",
			args = {
				"belowStairs",
				"stairs"
			}
		}
	}
}

data.sampleReadyPrompt = {
	prepare = {
		actions = {
			hero = { standAtLocation = "offScreenLeft" }
		}
	},
	proceed = {
		actions = {
			hero = { moveToPoint = "baseOfStairs" }
		},
		display = {
			flavor = "Nothing to do but climb...",
			prompt = { "Air Squats", 15 }
		}
	},
	conclude = {
	}
}

data.speciesData = {}

data.speciesData.legodude = {
	acceleration = 240,
	maxSpeed = 120,
	maxAngularSpeed = tau/2,
	angularAcceleration = tau/4,
	precision = tau/4
}

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

return data