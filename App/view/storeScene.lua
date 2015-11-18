--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local settings = require( "model.settingsModel" )
local session = require( "model.sessionModel" )
local analytics = require( "model.analyticsModel" )
local item = require( "element.storeItem" )

local backButton
local backButtonGroup

local storeItemTable = {}

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--- Composer functions.
-- Standard event handlers that are called by the Composer API when changing scenes.
-- @section composer

--- Called when the scene's view does not exist.
-- @tparam event event Event fired by the composer API.
function scene:create( event )
	local sceneGroup = self.view

	local testTable = {}
	testTable["data"] = 1
	testTable["data21"] = 2
	analytics:storeObject( "testData", testTable )

	local background = display.newImageRect( "img/questionBackground.png", display.contentHeight, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.alpha = 0.25
	sceneGroup:insert( background )

	-- Get the current number of points.
	print( "[Store Scene] Getting user info ")
	session.getInfo()
	local currentPoints = session.getPoints()

	local pointsTextOptions =
	{
	    --parent = textGroup,
	    text = "You've earned " .. currentPoints .. " points! \n Spend them here on cool stuff.",
	    x = display.contentCenterX,
	    y = 150,
	    width = display.contentWidth - 50,
	    font = native.systemFontBold,
	    fontSize = 24,
	    align = "center"  --new alignment parameter
	}
	local pointsText = display.newText( pointsTextOptions )
	pointsText:setFillColor( 0, 0, 0 )
	sceneGroup:insert( pointsText )

	backButton = display.newImageRect( "img/back.png", 100, 50 )
	backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	backButton.x = backButton.width/2 + 10
	backButton.y = backButton.height/2 + 10

	backButtonGroup = display.newGroup()
	backButtonGroup:insert( backButton )
	sceneGroup:insert( backButtonGroup )

	-- Make our store items one at a time
	-- TODO: Check if an item has already been purchased
	local storeItem1 = item:new(
		{
			imgName = "img/timeExtender.png",
			cost = 10,
			name = "Time Extender",
			description = "Adds 10 seconds to each puzzle, for the deliberate gamer.",
			type = "timeExtender",
			group = display.newGroup()
		} )
	storeItem1.group.x = display.contentCenterX/3
	storeItem1.group.y = display.contentCenterY - 10
	storeItemTable[storeItem1.group] = storeItem1
	sceneGroup:insert( storeItem1.group )

	local storeItem2 = item:new(
		{
			imgName = "img/boost.png",
			cost = 10,
			name = "Point Booster",
			description = "+10% points on all completed custom levels.",
			type = "booster",
			group = display.newGroup()
		} )
	storeItem2.group.x = display.contentCenterX
	storeItem2.group.y = display.contentCenterY - 10
	storeItemTable[storeItem2.group] = storeItem2
	sceneGroup:insert( storeItem2.group )

	local storeItem3 = item:new(
		{
			imgName = "img/leader.png",
			cost = 10,
			name = "Leaderboard Points",
			description = "Leaders get to make new custom games. And win. At life.",
			type = "points",
			group = display.newGroup()
		} )
	storeItem3.group.x = display.contentCenterX*5/3
	storeItem3.group.y = display.contentCenterY - 10
	storeItemTable[storeItem3.group] = storeItem3
	sceneGroup:insert( storeItem3.group )

	local storeItem4 = item:new(
		{
			imgName = "img/musicPack.png",
			cost = 10,
			name = "Alternate music pack #2.",
			description = "Changes the music to match the epicness of your performance.",
			type = "musicPack",
			group = display.newGroup()
		} )
	storeItem4.group.x = display.contentCenterX/3
	storeItem4.group.y = display.contentCenterY + 100
	storeItemTable[storeItem4.group] = storeItem4
	sceneGroup:insert( storeItem4.group )

	local storeItem5 = item:new(
		{
			imgName = "img/cats.png",
			cost = 10,
			name = "Cats",
			description = "Everything is cats. Yes, everything.",
			type = "theme",
			group = display.newGroup()
		} )
	storeItem5.group.x = display.contentCenterX
	storeItem5.group.y = display.contentCenterY + 100
	storeItemTable[storeItem5.group] = storeItem5
	sceneGroup:insert( storeItem5.group )

	local storeItem6 = item:new(
		{
			imgName = "img/noMusic.png",
			cost = 10,
			name = "No Music",
			description = "Turn off that infernal racket. For those who hate fun.",
			type = "musicPack",
			group = display.newGroup()
		} )
	storeItem6.group.x = display.contentCenterX*5/3
	storeItem6.group.y = display.contentCenterY + 100
	storeItemTable[storeItem6.group] = storeItem6
	sceneGroup:insert( storeItem6.group )
end

--- Called twice, once BEFORE, and once immediately after scene has moved onscreen.
-- @tparam event event Event fired by the composer API.
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	---------------------------------------
	-- BEFORE the scene has moved onscreen.
	---------------------------------------
	if ( phase == "will" ) then

		function backPressed( event )
			local phase = event.phase

			if phase == "began" then
				backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene("view.titleScene")
			end
		end

		backButtonGroup:addEventListener( "touch", backPressed )

		function itemPressed( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				-- Figure out which object they selected.
				for group, item in pairs( storeItemTable ) do
					if group == event.target then
						local storeOptions =
						{
							isModal = true,
							params =
							{
								object = item
							}
						}
						composer.showOverlay( "view.storeOverlay", storeOptions )
					end
				end
			end
		end

		for group, item in pairs(storeItemTable) do
			group:addEventListener( "touch", itemPressed )
		end
	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

	end
end

--- Called twice, once when the screen is about to, and once when it has finished moving offscreen.
-- @tparam event event Event fired by the composer API.
function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase

	----------------------------------------------
	-- When the screen is about to move offscreen.
	----------------------------------------------
	if ( phase == "will" ) then

	------------------------------------------------
	-- When the scene has finished moving offscreen.
	------------------------------------------------
	elseif ( phase == "did" ) then

	end
end

--- Called prior to removal of scene's view (can be recycled or removed).
-- @tparam event event Event fired by the composer API.
function scene:destroy( event )
	local sceneGroup = self.view

	-----------------------------------------------------------------------------
	-- Called prior to the removal of scene's view ("sceneGroup").
	-- Insert code here to clean up the scene.
	-- Example: remove display objects, save state, etc.
	-----------------------------------------------------------------------------

end

--- Custom functions.
-- Custom functions that provide additional functionality and are called from this Scene or its associated controller.
-- @section custom

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
