local data = {}

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
data.width = width; data.height = height
data.co = { xn, yn, xn - width/2 , yn - height/2, xn + width/2, yn + height/2 }

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

return data