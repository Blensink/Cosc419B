--- Session Model
-- Model to keep track of user sessions.
-- @module model
sessionModel = {}

local json = require( "json" )
local network = require( "model.networkModel" )

local lfs = require( "lfs" )

local userInfo = {}
local seenDisclaimer = false

--- Save a user's info to the file system.
function sessionModel:saveInfo()
	--userInfo["seenDisclaimer"] = seenDisclaimer
	userInfo["userId"] = system.getInfo( "deviceID" )
	local output = json.encode( userInfo )

	local path = system.pathForFile( "userInfo.txt", system.DocumentsDirectory )
	local file, errorString = io.open( path, "w" )

	if not file then
	  print( "File error: " .. errorString )
	else
	  file:write( output )
	  io.close( file )
	end

	file = nil
end

--- Read the session info stored locally.
function sessionModel:getInfo()
	local path = system.pathForFile( "userInfo.txt", system.DocumentsDirectory )

	local file, errorString = io.open( path, "r" )

	if not file then
	  print( "File error: " .. errorString )
	else
	  local contents = file:read( "*a" )
	  userInfo = json.decode( contents )
	  io.close( file )
	end

	file = nil
end

--- Get the device id stored locally.
-- @return The device id.
function sessionModel:getId()
	return system.getInfo( "deviceID" )
end

--- Log that the user has seen the disclaimer.
function sessionModel:seenDisclaimer()
	userInfo["seenDisclaimer"] = true
--	seenDisclaimer = true
end

--- Check if the user has seen the disclaimer.
-- @return true if they have, false if not.
function sessionModel:hasSeenDisclaimer()
	return userInfo["seenDisclaimer"]--seenDisclaimer
end

--- Set the current level for a user.
-- @param level The level to set.
function sessionModel:setLevel( level )
	userInfo["currentLevel"] = level
	-- Why doesnt this work..
	--self.saveInfo()
end

--- Advance a user's current level.
function sessionModel:nextLevel()
	userInfo["currentLevel"] = userInfo["currentLevel"] + 1
end

--- Get the user's current level.
-- @return The current level.
function sessionModel:level()
	if userInfo['currentLevel'] == nil then
		return 0
	else
		return userInfo['currentLevel']
	end
end

--- Get the user's current level.
-- @return The current level.
function sessionModel:getCurrentLevel()
	if userInfo["currentLevel"] == nil then
		userInfo["currentLevel"] = 0
	else
		currentLevel = userInfo["currentLevel"]
	end

	local currentLevel = userInfo["currentLevel"]
	local path = system.pathForFile( "levels.txt", system.ResourceDirectory )
	local file, errorString = io.open( path, "r" )

	if not file then
	  print( "File error: " .. errorString )
	else
	  local contents = file:read( "*a" )
	  levelInfo = json.decode( contents )
	  io.close( file )
	  return levelInfo[tostring(currentLevel)]
	end

	file = nil
end

--- Get a level's data.
-- @param levelName The name for the level we're looking for.
function sessionModel:getLevel( levelName )
	local path = system.pathForFile( "levels.txt", system.ResourceDirectory )
	local file, errorString = io.open( path, "r" )

	if not file then
	  print( "File error: " .. errorString )
	else
	  local contents = file:read( "*a" )
	  local levelInfo = json.decode( contents )
	  io.close( file )
	  return levelInfo[levelName]
	end

	file = nil
end

--- Make a level json and store it on the device.
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

	local path = system.pathForFile( "levels.txt", system.ResourceDirectory )
	local file, errorString = io.open( path, "w" )

	if not file then
	  print( "File error: " .. errorString )
	else
	  file:write( json.encode(levelTable) )
	  io.close( file )
	end
	file = nil
end

--- Log the tutorial as complete.
function sessionModel:setTutorialComplete()
	userInfo["tutorialComplete"] = true
	self.saveInfo()
end

--- Check if the tutorial is complete.
-- @return True if complete, false if not.
function sessionModel:tutorialComplete()
	return userInfo["tutorialComplete"]
end

--- Log the story as completed.
function sessionModel:setStoryDone()
	userInfo["storyDone"] = true
	self.saveInfo()
end

--- Check if the story is done.
-- @return True if it's been completed, false if not.
function sessionModel:checkIfStoryDone()
	if userInfo["storyDone"] then
		return true
	else
		return false
	end
end

----------------------------------------------------------------------------------------------------
-- Custom Game Stuff.
----------------------------------------------------------------------------------------------------

--- Get the icon pack.
function sessionModel:getIconPack()
	local path = system.pathForFile( "icons.txt", system.ResourceDirectory )
	local file, errorString = io.open( path, "r" )

	if not file then
		print( "File error: " .. errorString )
	else
	  local contents = file:read( "*a" )
	  local iconPack = json.decode( contents )
	  io.close( file )
		return iconPack
	end

	file = nil
end

--- Write a custom game out to the device.
-- @param puzzleTable The icons and answers for the puzzle.
function sessionModel:writeLevel( puzzleTable )
	local folderPath = system.pathForFile( "", system.DocumentsDirectory )
	lfs.chdir( folderPath )
	if not lfs.chdir( "games/" ) then
		lfs.mkdir( "games/" )
		lfs.chdir( "games/" )
	end

	local path = system.pathForFile( "games/" .. tostring(math.random( 0, 10000000 )) ..
		".txt", system.DocumentsDirectory )
	local file, errorString = io.open( path, "w" )

	if not file then
	  print( "File error: " .. errorString )
	else
	  file:write( json.encode( puzzleTable ) )
	  io.close( file )
	end

	file = nil
end

--- Retrieve a random custom level.
-- @return The level info.
function sessionModel:getRandomCustomLevel()
	local fileTable = {}

	local path = system.pathForFile( "games/", system.DocumentsDirectory )
	for file in lfs.dir(path) do
  	if ( string.sub( file, string.len(file)-3, string.len(file) ) == ".txt" ) then
  		table.insert( fileTable, file )
  	end
	end

	if #fileTable >= 1 then
		index = math.random( 1, #fileTable )
		local newLevel = system.pathForFile( "games/"..fileTable[index], system.DocumentsDirectory )
		local file, errorString = io.open( newLevel, "r" )

		if not file then
		  print( "File error: " .. errorString )
		else
			local contents = file:read( "*a" )
		  levelInfo = json.decode( contents )
		  io.close( file )
		  return levelInfo
		end
	end

	file = nil
end

--- Get a count of custom levels stored.
-- @return The count of levels
function sessionModel:getCustomLevelCount()
	local fileTable = {}

	local path = system.pathForFile( "games/", system.DocumentsDirectory )
	for file in lfs.dir(path) do
  	if ( string.sub( file, string.len(file)-3, string.len(file) ) == ".txt" ) then
  		table.insert( fileTable, file )
  	end
	end

	return #fileTable
end

--- Get a user's points.
-- @return The user's points.
function sessionModel:getPoints()
	if userInfo["points"] == nil then
		return 0
	else
		return userInfo["points"]
	end
end

--- Add points for a user.
-- @param amount The amount of points to add.
function sessionModel:addPoints( amount )
	if userInfo["points"] == nil then
		userInfo["points"] = amount
	else
		userInfo["points"] = userInfo["points"] + amount
	end
end

--- Subtract points from a user.
-- @return True if the points were removed successfully, false if not.
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

----------------------------------------------------------------------------------------------------
-- Store Related Session Tracking.
----------------------------------------------------------------------------------------------------

--- Check if a user has bought an item yet.
-- @param itemName The item we're checking.
-- @return True if they've bought it already, false if not.
function sessionModel:checkIfBought( itemName )
	if userInfo[itemName] == nil or userInfo[itemName] == false then
		return false
	elseif userInfo[itemName] == true then
		return true
	else
		return false
	end
end

--- Log an item as bought.
-- @param itemName The item bought.
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

--- Set an item as active.
-- @param Type The type of item to set.
-- @param name The name of the item.
function sessionModel:setActiveItem( type, name )
	userInfo[type] = name
end

--- Get the audio track that's current set.
-- @param The name of the audio track currently set.
function sessionModel:getAudioTrack()
	return userInfo[musicPack]
end

--- Get the user's current leaderboard spot.
--- @return The current percentile
function sessionModel:getLeaderboardPlace()
	return math.random(0,100)
end

return sessionModel
