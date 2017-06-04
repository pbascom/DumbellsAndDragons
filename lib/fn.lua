local data, theme = require "lib.data", require "lib.theme"
local spine, widget = require "lib.spine", require "widget"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local fn = {}

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
	print( skeleton.group.name )

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