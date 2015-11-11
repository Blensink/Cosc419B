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

function tutorialCompleted()
	parse:logEvent( "TutorialComplete", { ["time"] = 1 } )
end

function analyticsModel:puzzleFinished( puzzleId, startTime, endTime )
	parse:logEvent( "PuzzleComplete", { ["time"] = endTime-startTime, ["puzzle"] = puzzleId } )
end

function analyticsModel:puzzleAbandon( puzzleId )
	parse:logEvent( "puzzleAbandon", { ["puzzleId"] = puzzleId } )
end

return analyticsModel