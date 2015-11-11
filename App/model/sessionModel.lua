sessionModel = {}

local json = require( "json" )

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
	    print( "User info contents: ")
	    userInfo = json.decode( contents )
	    for k,v in pairs(userInfo) do
	    	print("\t",k,v)
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

return sessionModel