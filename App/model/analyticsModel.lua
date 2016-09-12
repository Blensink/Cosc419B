analyticsModel = {}

local json = require( "json" )
local parse = require( "model.parse" )

--- Initialize parse analytics.
function analyticsModel:init()
	parse:init(	{
		appId = "FSMofRFb6nWCHZxZRBN198psfYgl0JAWCvyKyl4Q",
		apiKey = "QWQaGFMwzgScI6TOBzxq29x5sj7cuR07j8HMH1Td"
	} )
end

--- Log an app opened event with parse.
function analyticsModel:appOpened()
	parse.showStatus = true
	parse:appOpened()
end

--- Log a tutorial started event with parse.
function analyticsModel:tutorialStarted()
	parse:logEvent( "TutorialStart", { ["time"] = 1 } )
end

--- Log a tutorial completed event with parse.
function analyticsModel:tutorialCompleted()
	parse:logEvent( "TutorialComplete", { ["time"] = 1 } )
end

--- Log a puzzle finished event with parse.
-- @param puzzleId The puzzle completed.
-- @param timeElapsed The time taken to finish the puzzle.
-- @param pointsEarned The points earned for completing the puzzle.
function analyticsModel:puzzleFinished( puzzleId, timeElapsed, pointsEarned )
	parse:logEvent( "PuzzleComplete", {
		["time"] = timeElapsed,
		["puzzle"] = puzzleId,
		["id"] = system.getInfo( "deviceID" )
	} )
	self:storeObject( "pointsEarned", pointsEarned )
end

--- Log a puzzle abandoned event with parse.
-- @param The id of the puzzle.
function analyticsModel:puzzleAbandon( puzzleId )
	parse:logEvent( "puzzleAbandon", {
		["puzzleId"] = puzzleId,
		["id"] = system.getInfo( "deviceID" )
	} )
end

--- Store the points earned.
function analyticsModel:storePoints()
end

--- Store an object in parse.
-- @param class The class to store.
-- @param data The data to store.
function analyticsModel:storeObject( class, data )
		local function onCreateObject( event )
			for k, v in pairs( event ) do
				print( k,v )
			end
			if not event.error then
				print( event.response.createdAt )
			end
		end
		parse:createObject( class, data, onCreateObject )
end

return analyticsModel
