local spine = require "lib.spine"

local util = {}

function util.loadSkeleton( name, scale, animation, skin )
	print( "util.loadSkeleton is called" )

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
	animationStateData.defaultMix = 0.2 --Find out what this does
	local animationState = spine.AnimationState.new( animationStateData )

	skeleton.group.isVisible = false

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

	return { skeleton = skeleton, state = animationState }

end

return util