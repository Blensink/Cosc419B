--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local sessionModel = require( "model.sessionModel" )
local settings = require( "model.settingsModel" )
local analytics = require( "model.analyticsModel" )

local titleGroup
local storyButtonGroup
local tutorialButtonGroup
local creditsButtonGroup
local customButtonGroup
local storeButtonGroup

local storyButton
local tutorialButton
local creditsButton
local customButton
local storeButton

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

	local background = display.newImageRect( "img/questionBackground.png", display.contentHeight, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.alpha = 0.25

	local titleImage = display.newImageRect( "img/title.png", 300, 180 )
	titleImage.x = display.contentCenterX
	titleImage.y = display.contentCenterY - 150

	local titleGroup = display.newGroup()
	titleGroup:insert( titleImage )

	storyButton = display.newImageRect( "img/story.png", 100, 50 )
	storyButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	storyButton.x = display.contentCenterX
	storyButton.y = display.contentCenterY

	storyButtonGroup = display.newGroup()
	storyButtonGroup:insert( storyButton )

	tutorialButton = display.newImageRect( "img/tutorial.png", 100, 50 )
	tutorialButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	tutorialButton.x = display.contentCenterX/2
	tutorialButton.y = display.contentCenterY + 100

	tutorialButtonGroup = display.newGroup()
	tutorialButtonGroup:insert( tutorialButton )

	creditsButton = display.newImageRect( "img/credits.png", 100, 50 )
	creditsButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	creditsButton.x = display.contentCenterX*3/2
	creditsButton.y = display.contentCenterY + 100

	creditsButtonGroup = display.newGroup()
	creditsButtonGroup:insert( creditsButton )

	customButton = display.newImageRect( "img/credits.png", 100, 50 )
	customButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	customButton.x = display.contentCenterX*3/2
	customButton.y = display.contentCenterY + 200

	customButtonGroup = display.newGroup()
	customButtonGroup:insert( customButton )

	storeButton = display.newImageRect( "img/credits.png", 100, 50 )
	storeButton:setFillColor( unpack( settings.getButtonOffColor() ) )
	storeButton.x = display.contentCenterX/2
	storeButton.y = display.contentCenterY + 200

	storeButtonGroup = display.newGroup()
	storeButtonGroup:insert( storeButton )

	sceneGroup:insert( background )
	sceneGroup:insert( titleGroup )
	sceneGroup:insert( storyButtonGroup )
	sceneGroup:insert( tutorialButtonGroup )
	sceneGroup:insert( creditsButtonGroup )
	sceneGroup:insert( customButtonGroup )
	sceneGroup:insert( storeButtonGroup )
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

		------------------------------------------------------------------------------
		-- Called when the scene is still off screen (but is about to come on screen).
		------------------------------------------------------------------------------

	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

		-----------------------------------------------------------------------------
		-- Called when the scene is now on screen.
		-- Insert code here to make the scene come alive.
		-- Example: start timers, begin animation, play audio, etc.
		-----------------------------------------------------------------------------
		function storyPressed( event )
			local phase = event.phase

			if phase == "began" then
				storyButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				storyButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				local level = sessionModel.level()
				print( "[TitleScene] Loading level:", sessionModel.level())
				composer.gotoScene( "view.story.storyScene" .. level )
			end
		end

		function tutorialPressed( event )
			local phase = event.phase

			if phase == "began" then
				tutorialButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				tutorialButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene( "view.tutorialScene" )
			end
		end

		function creditsPressed( event )
			local phase = event.phase

			if phase == "began" then
				creditsButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				creditsButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene( "view.creditsScene" )
			end
		end

		function customPressed( event )
			local phase = event.phase

			if phase == "began" then
				customButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				customButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene( "view.customGameScene" )
			end
		end

		function storePressed( event )
			local phase = event.phase

			if phase == "began" then
				storeButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				storeButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.gotoScene( "view.storeScene" )
			end
		end

		storyButtonGroup:addEventListener( "touch", storyPressed )
		tutorialButtonGroup:addEventListener( "touch", tutorialPressed )
		creditsButtonGroup:addEventListener( "touch", creditsPressed )
		customButtonGroup:addEventListener( "touch", customPressed )
		storeButtonGroup:addEventListener( "touch", storePressed )

		-- Last things last begin the music TODO: RESUME MUSIC
	--	local backgroundMusic = audio.loadStream( "sound/elevatormusic1.wav")
	--	local backgroundMusicPlaying = audio.play( backgroundMusic, { loops = -1, fadein = 1000 } )

		-- Log the app open event
		analytics:init()
		analytics.appOpened()
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

		storyButtonGroup:removeEventListener( "touch", storyPressed )
		tutorialButtonGroup:removeEventListener( "touch", tutorialPressed )
		creditsButtonGroup:removeEventListener( "touch", creditsPressed )
		customButtonGroup:removeEventListener( "touch", customPressed )
		storeButtonGroup:removeEventListener( "touch", storePressed )

		audio.stop()
		-----------------------------------------------------------------------------
		-- Called when the scene is on screen (but is about to go off screen).
		-- Insert code here to "pause" the scene.
		-- Example: stop timers, stop animation, stop audio, etc.
		-----------------------------------------------------------------------------

	------------------------------------------------
	-- When the scene has finished moving offscreen.
	------------------------------------------------
	elseif ( phase == "did" ) then

		-----------------------------------------------------------------------------
		-- Called immediately after scene goes off screen.
		-----------------------------------------------------------------------------

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
