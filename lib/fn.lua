local data, theme = require "lib.data", require "lib.theme"
local spine, widget = require "lib.spine", require "widget"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local tau = 2*math.pi
local sin, cos, max, min = math.sin, math.cos, math.max, math.min
local random, abs, deg = math.random, math.abs, math.deg




local fn = {}

--[[
		Convenience functions
--]]

-- Parses a color, and unpacks it if it's an array.
function fn.cparse( input )
	if type( input ) == "number" then return input end
	return unpack( input )
end

-- Returns the distance between two points, given as { x1, y1 } and { x2, y2 }
function fn.getDistance( p1, p2 )
	return math.sqrt( (p2[1]-p1[1])^2 + (p2[2]-p1[2])^2 )
end

-- Checks if a point is inside the boundaries
function fn.inBounds( p )
	return p[1] > xo and p[1] < xf and p[2] > yo and p[2] < yf
end

-- Returns a random number between -1 and 1, with results closer to 0 more probable
function fn.randomBinomial()
	return random() - random()
end

-- Returns 1 or -1 randomly
function fn.coinFlip()
	if random() >= 0.5 then return 1 end
	return -1
end

-- Normalizes a vector
function fn.normalize( vector )
	local total = 0
	for i,value in ipairs( vector ) do
		total = total + value^2
	end
	total = math.sqrt( total )
	for i,value in ipairs( vector ) do
		vector[i] = value/total
	end
	return vector
end

-- Implement inheritance for object-oriented programming
function fn.inheritsFrom( baseClass )
	local newClass = {}
	local classMetatable = { __index = new_class }

	if not baseClass then return end

	function newClass.new()
		local self = {}
		setmetatable( self, classMetatable )
		return self
	end

	setmetatable( newClass, { __index = baseClass } )

	return newClass
end


--[[
		Table modifications
--]]

fn.betterTable = {}
fn.betterMetatable = { __index = fn.betterTable }

function fn.betterTable:contains( object )
	local containsObject = false
	for key, value in pairs( self ) do
		if value == object then containsObject = true end
	end
	return containsObject
end

--[[
		Spine utility
--]]
function fn.loadSpineObject( name, scale, skin )

	local imageLoader = function( file )
		local paint = { type = "image", filename = "assets/atlas/" .. file }
		return paint
	end

	local atlas = spine.TextureAtlas.new( spine.utils.readFile( "assets/atlas/" .. name .. ".atlas" ), imageLoader )

	local json = spine.SkeletonJson.new( spine.AtlasAttachmentLoader.new( atlas ) )
	json.scale = scale
	local skeletonData = json:readSkeletonDataFile( "assets/spine/" .. name .. ".json" )
	local skeleton = spine.Skeleton.new( skeletonData )
	skeleton.flipY = true
	--skeleton.group.x = x
	--skeleton.group.y = y

	if skin then skeleton:setSkin( skin ) end

	local animationStateData = spine.AnimationStateData.new( skeletonData )
	animationStateData.defaultMix = 0.2
	local animationState = spine.AnimationState.new( animationStateData )

	skeleton.group.isVisible = true

	skeleton.group.name = name

	--event callbacks
	animationState.onStart = function (entry)
		print(entry.trackIndex.." start: "..entry.animation.name)
	end
	animationState.onInterrupt = function (entry)
		print(entry.trackIndex.." interrupt: "..entry.animation.name)
	end
	animationState.onEnd = function (entry)
		print(entry.trackIndex.." end: "..entry.animation.name)
	end
	animationState.onComplete = function (entry)
		print(entry.trackIndex.." complete: "..entry.animation.name)
	end
	animationState.onDispose = function (entry)
		print(entry.trackIndex.." dispose: "..entry.animation.name)
	end
	animationState.onEvent = function (entry, event)
		print(entry.trackIndex.." event: "..entry.animation.name..", "..event.data.name..", "..event.intValue..", "..event.floatValue..", '"..(event.stringValue or "").."'")
	end

	return { skeleton = skeleton, animationState = animationState }

end

return fn