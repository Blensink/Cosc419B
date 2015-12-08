sessionModel = {}

local json = require( "json" )
local network = require( "model.networkModel" )

local lfs = require( "lfs" )

local userInfo = {}
local seenDisclaimer = false

function sessionModel:saveInfo()
	--userInfo["seenDisclaimer"] = seenDisclaimer
	local output = json.encode( userInfo )

	-- Path for the file to write
	local path = system.pathForFile( "userInfo.txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "w" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Write data to file
	    file:write( output )
	    print( "[SessionModel] Writing out user info:", output )

	    -- Close the file handle
	    io.close( file )
	end

	file = nil
end

function sessionModel:getInfo()
	-- Path for the file to read
	local path = system.pathForFile( "userInfo.txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Read data from file
	    local contents = file:read( "*a" )

	    -- Output the file contents
	    print( " \t User info contents: ")
	    userInfo = json.decode( contents )
	    for k,v in pairs(userInfo) do
	    	print("\t\t",k,v)
	    end
	    print("\n")
	    	    -- Close the file handle
	    io.close( file )
	end

	file = nil
end

function sessionModel:seenDisclaimer()
	userInfo["seenDisclaimer"] = true
--	seenDisclaimer = true
end

function sessionModel:hasSeenDisclaimer()
	return userInfo["seenDisclaimer"]--seenDisclaimer
end

function sessionModel:setLevel( level )
	userInfo["currentLevel"] = level

	-- Why doesnt this work..
	--self.saveInfo()
end

function sessionModel:nextLevel()
	userInfo["currentLevel"] = userInfo["currentLevel"] + 1
end

function sessionModel:level()
	if userInfo['currentLevel'] == nil then
		return 0
	else
		return userInfo['currentLevel']
	end
end

function sessionModel:getCurrentLevel()
	if userInfo["currentLevel"] == nil then
		userInfo["currentLevel"] = 0
	else
		currentLevel = userInfo["currentLevel"]
	end

	local currentLevel = userInfo["currentLevel"]

	-- First get the JSON holding all the levels.
		-- Path for the file to read
	local path = system.pathForFile( "levels.txt", system.ResourceDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Read data from file
	    local contents = file:read( "*a" )

	    levelInfo = json.decode( contents )

	    -- Close the file handle
	    io.close( file )

	    return levelInfo[tostring(currentLevel)]
	end

	file = nil
end

function sessionModel:getLevel( levelName )
	print( "[SessionModel] Getting level: ", levelName)
	-- First get the JSON holding all the levels.
		-- Path for the file to read
	local path = system.pathForFile( "levels.txt", system.ResourceDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Read data from file
	    local contents = file:read( "*a" )
	    local levelInfo = json.decode( contents )

	    -- Close the file handle
	    io.close( file )
	    print( "[SessionModel] Level info:" )
	    for k,v in pairs(levelInfo) do
	    	print("\t",k,v)
	    end
	    print("\n")
	    return levelInfo[levelName]
	end

	file = nil
end

function sessionModel:makeLevelJSON()
	local levelTable = {}

	levelTable["0"] = {}
	table.insert( levelTable["0"], {"cat", 1 } )
	table.insert( levelTable["0"], { "dog", 2 } )

	levelTable["1"] = {}
	table.insert( levelTable["1"], {"cat", 1 } )
	table.insert( levelTable["1"], { "dog", 2 } )
	table.insert( levelTable["1"], {"cat", 1 } )
	table.insert( levelTable["1"], { "dog", 2 } )

	-- Path for the file to write
	local path = system.pathForFile( "levels.txt", system.ResourceDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "w" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Write data to file
	    file:write( json.encode(levelTable) )

	    -- Close the file handle
	    io.close( file )
	end

	file = nil
end

function sessionModel:setTutorialComplete()
	userInfo["tutorialComplete"] = true

	self.saveInfo()
end

function sessionModel:tutorialComplete()
	return userInfo["tutorialComplete"]
end

--------------------------------------------------------------------------------
--                                                                            --
-- Custom Game Stuff.                                                         --
--                                                                            --
--------------------------------------------------------------------------------

function sessionModel:getIconPack()
	print( "[SessionModel] Getting Icon Pack" )

	local path = system.pathForFile( "icons.txt", system.ResourceDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Read data from file
	    local contents = file:read( "*a" )
	    local iconPack = json.decode( contents )

	    -- Close the file handle
	    io.close( file )

		return iconPack
	end

	file = nil
end

function sessionModel:writeLevel( puzzleTable )
	print( "[SessionModel] Writing out custom level" )

	-- Check if there's already a custom game folder, if not make it.
	local folderPath = system.pathForFile( "", system.DocumentsDirectory )
	lfs.chdir( folderPath )
	if not lfs.chdir( "games/" ) then
		lfs.mkdir( "games/" )
		lfs.chdir( "games/" )
	end

	print( "Writing out twice for something")
	-- Path for the file to write
	local path = system.pathForFile( "games/" .. tostring(math.random( 0, 10000000 )) .. ".txt", system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( path, "w" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Write data to file
	    print( json.encode(puzzleTable))
	    file:write( json.encode( puzzleTable ) )

	    -- Close the file handle
	    io.close( file )
	end

	file = nil
end

function sessionModel:getRandomCustomLevel()
	print( "[SessionModel] Getting a random custom level." )

	local fileTable = {}

	local path = system.pathForFile( "games/", system.DocumentsDirectory )
	for file in lfs.dir(path) do
   		-- Hacky way to make sure the file is a .txt and therefore a game.
   		if ( string.sub( file, string.len(file)-3, string.len(file) ) == ".txt" ) then
   			table.insert( fileTable, file )
   		end
	end

	index = math.random( 1, #fileTable )
	local newLevel = system.pathForFile( "games/"..fileTable[index], system.DocumentsDirectory )

	-- Open the file handle
	local file, errorString = io.open( newLevel, "r" )

	if not file then
	    -- Error occurred; output the cause
	    print( "File error: " .. errorString )
	else
	    -- Read data from file
	    local contents = file:read( "*a" )

	    levelInfo = json.decode( contents )

	    -- Close the file handle
	    io.close( file )

	    return levelInfo
	end

	file = nil
end

function sessionModel:getPoints()
	if userInfo["points"] == nil then
		return 0
	else
		return userInfo["points"]
	end
end

function sessionModel:addPoints( amount )
	if userInfo["points"] == nil then
		userInfo["points"] = amount
	else
		userInfo["points"] = userInfo["points"] + amount
	end
end

function sessionModel:subtractPoints( amount )
	local points = tonumber( userInfo["points"] )

	if points == nil then
		return false
	elseif points < amount then
		return false
	else
		userInfo["points"] = userInfo["points"] - amount

		return true
	end
end

--------------------------------------------------------------------------------
--                                                                            --
-- Store Related Session Tracking.                                            --
--                                                                            --
--------------------------------------------------------------------------------

function sessionModel:checkIfBought( itemName )
	if userInfo[itemName] == nil or userInfo[itemName] == false then
		return false
	elseif userInfo[itemName] == true then
		return true
	else
		return false
	end
end

function sessionModel:setItemBought( itemName )
	if itemName == "Leaderboard Points" then
		if userInfo[itemName] == nil then
			userInfo[itemName] = 1
		else
			userInfo[itemName] = userInfo[itemName] + 1
		end
	else
		userInfo[itemName] = true
	end
end

function sessionModel:setActiveItem( type, name )
	userInfo[type] = name
end

function sessionModel:getAudioTrack()
	return userInfo[musicPack]
end

return sessionModel
