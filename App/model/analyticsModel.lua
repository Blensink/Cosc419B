analyticsModel = {}

local json = require( "json" )
local parse = require( "model.parse" )

function analyticsModel:init()
	parse:init(
		{
			appId = "FSMofRFb6nWCHZxZRBN198psfYgl0JAWCvyKyl4Q",
			apiKey = "QWQaGFMwzgScI6TOBzxq29x5sj7cuR07j8HMH1Td"
		}
	)
end

function analyticsModel:appOpened()
	parse.showStatus = true
	parse:appOpened()
end

function analyticsModel:tutorialStarted()
	parse:logEvent( "TutorialStart", { ["time"] = 1 } )
end

function analyticsModel:tutorialCompleted()
	parse:logEvent( "TutorialComplete", { ["time"] = 1 } )
end

function analyticsModel:puzzleFinished( puzzleId, timeElapsed, pointsEarned )
	parse:logEvent( "PuzzleComplete", { ["time"] = timeElapsed, ["puzzle"] = puzzleId, ["id"] = system.getInfo( "deviceID" ) } )
	self:storeObject( "pointsEarned", pointsEarned )
end

function analyticsModel:puzzleAbandon( puzzleId )
	parse:logEvent( "puzzleAbandon", { ["puzzleId"] = puzzleId, ["id"] = system.getInfo( "deviceID" ) } )
end

function analyticsModel:storePoints()
end

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
