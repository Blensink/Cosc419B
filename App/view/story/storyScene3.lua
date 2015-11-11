--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local displayGroup
local redoButtonGroup
local homeButtonGroup

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

	-----------------------------------------------------------------------------
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	-----------------------------------------------------------------------------
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
		displayGroup = display.newGroup()

		--TODO: Change this to an artsy background.
		local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
		background:setFillColor( { 0, 0, 0} )
		background.alpha = 0.4
		displayGroup:insert( background )

		local backgroundImage = display.newImageRect( "img/questionBackground.png", display.contentHeight, display.contentHeight )
		backgroundImage.x = display.contentCenterX
		backgroundImage.y = display.contentCenterY
		backgroundImage.alpha = 0.2
		displayGroup:insert( backgroundImage )

		local femScientist = display.newImageRect( "img/femaleScientist.png", 175, 200 )
		femScientist.x = femScientist.width/2
		femScientist.y = display.contentCenterX + femScientist.height/2 + 100
		displayGroup:insert( femScientist )

		local scientist = display.newImageRect( "img/scientistEyebrows.png", 150, 240 )
		scientist.x = display.contentWidth - scientist.width/2
		scientist.y = display.contentCenterX + scientist.height/2 + 100
		displayGroup:insert( scientist )

		local speechBubble = display.newImageRect( "img/storySpeech4.png", 300, 250 )
		speechBubble.x = display.contentCenterX
		speechBubble.y = display.contentCenterY - 100
		displayGroup:insert( speechBubble )

		-- TODO: make/replace story button
		local redoButton = display.newImageRect( "img/redo.png", 125, 50 )
		redoButton.x = redoButton.width/2 + 15
		redoButton.y = display.contentHeight - redoButton.height/2 - 15

		redoButtonGroup = display.newGroup()
		redoButtonGroup:insert( redoButton )
		displayGroup:insert( redoButtonGroup )

		-- TODO: make/replace story button
		local homeButton = display.newImageRect( "img/home.png", 125, 50 )
		homeButton.x = display.contentWidth - homeButton.width/2 - 15
		homeButton.y = display.contentHeight - homeButton.height/2 - 15

		homeButtonGroup = display.newGroup()
		homeButtonGroup:insert( homeButton )
		displayGroup:insert( homeButtonGroup )

		sceneGroup:insert( displayGroup )
	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

		-----------------------------------------------------------------------------
		-- Called when the scene is now on screen.
		-- Insert code here to make the scene come alive.
		-- Example: start timers, begin animation, play audio, etc.
		-----------------------------------------------------------------------------
		function redoButtonPressed( event )
			sessionModel.setLevel( 0 )
			composer.gotoScene( "view.titleScene" )
		end

		function homeButtonPressed( event )
			composer.gotoScene( "view.titleScene")
		end

		redoButtonGroup:addEventListener( "touch", redoButtonPressed )
		homeButtonGroup:addEventListener( "touch", homeButtonPressed )

		local backgroundMusic = audio.loadSound( "sound/story1.wav")
		local backgroundMusicPlaying = audio.play( backgroundMusic )
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

		-----------------------------------------------------------------------------
		-- Called when the scene is on screen (but is about to go off screen).
		-- Insert code here to "pause" the scene.
		-- Example: stop timers, stop animation, stop audio, etc.
		-----------------------------------------------------------------------------
		displayGroup:removeEventListener( "touch", screenPressed )
	------------------------------------------------
	-- When the scene has finished moving offscreen.
	------------------------------------------------
	elseif ( phase == "did" ) then

		-----------------------------------------------------------------------------
		-- Called immediately after scene goes off screen.
		-----------------------------------------------------------------------------
		audio.stop()
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