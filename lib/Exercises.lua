local fn = require "lib.fn"

local Exercises = {}

local eVars = {
	ranger = {
		noncore = {},
		core = {}
	}
}

-- Ranger noncore
eVars.ranger.noncore[ "1" ] = {
	{ id = "airSquat", prompt = "Air Squats", anim = "airSquat" },
	--{ id = "shuffle", prompt = "Shuffles", anim = "airSquat" },
	{ id = "lunge", prompt = "Lunges", anim = "lunge" }
}
eVars.ranger.noncore[ "6" ] = {
	{ id = "highKnee", prompt = "High Knees", anim = "highKnee" },
	{ id = "buttKick", prompt = "Butt Kicks", anim = "buttKick" },
	--{ id = "karaoke", prompt = "Karaokes", anim = "highKnee" },
	--{ id = "sprint", prompt = "Sprints", anim = "run" }
}
eVars.ranger.noncore[ "11" ] = {
	--{ id = "longJump", prompt = "Long Jumps", anim = "burpee" },
	{ id = "singleLegHop", prompt = "Single Leg Hops", anim = "singleLegHop_right" },
	{ id = "squatJump", prompt = "Squat Jumps", anim = "airSquat" }
}

--Ranger core
eVars.ranger.core[ "1" ] = {
	{ id = "flutterKick", prompt = "Flutter Kicks", anim = "flutterKick" },
	{ id = "plank", prompt = "Plank", anim = "plank" },
	{ id = "birdDog", prompt = "Bird Dogs", anim = "birdDog_right" },
	--{ id = "russianTwist", prompt = "Russian Twists", anim = "birdDog" }
}
eVars.ranger.core[ "6" ] = {
	{ id = "burpee", prompt = "Burpees", anim = "burpee" },
	{ id = "bicycle", prompt = "Bicycles", anim = "bicycle" },
	--{ id = "sidePlank", prompt = "Side Plank", anim = "birdDog" }
}
eVars.ranger.core[ "11" ] = {
	{ id = "mountainClimber", prompt = "Mountain Climbers", anim = "mountainClimber" },
	{ id = "verticalLegLift", prompt = "Vertical Leg Lifts", anim = "verticalLegLift" },
	--{ id = "lateralFlutterKick", prompt = "Flutter Kicks", anim = "birdDog" }
}


-- Note to future Phil: implement parsing by commas to the category argument, so we can do
-- calls to multiple categories. I'd do it now, but I'm not sure it'll be necessary yet.
function Exercises.new( class, category, level, avoidances )
	local shortList = {}; local listLength = 0
	for minLevel, table in pairs( eVars[ class ][ category ] ) do
		if level >= tonumber( minLevel ) then
			for index, exercise in ipairs( table ) do
				listLength = listLength + 1
				shortList[ listLength ] = exercise
			end
		end
	end


	if avoidances == nil then avoidances = {} end
	local index
	repeat
		index = math.random( 1, listLength )
	until fn.contains( avoidances, shortList[ index ] ) ~= true

	return shortList[ index ]
end

return Exercises