--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local gotoTutorialButtonGroup
local skipButtonGroup
local overlayGroup = display.newGroup()

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
	local background = display.newRect( display.contentCenterX, display.contentCenterY,
    display.contentWidth, display.contentHeight )
	background:setFillColor( { 0, 0, 0} )
	background.alpha = 0.3

	local backgroundRect = display.newRect( display.contentCenterX, display.contentCenterY,
    display.contentWidth - 50, display.contentHeight/3 )
	background:setFillColor( { 1, 1, 1 } )

	local gameText = display.newImageRect( "img/tutorialNotDone.png", 250, 125 )
	gameText.x = display.contentCenterX
	gameText.y = backgroundRect.y - backgroundRect.height/2 + gameText.height/2

	local skipButton = display.newImageRect( "img/skip.png", 100, 50 )
	skipButton.x = backgroundRect.x/2
	skipButton.y = backgroundRect.y + backgroundRect.height/2 - skipButton.height/2
	skipButtonGroup = display.newGroup()
	skipButtonGroup:insert( skipButton )

	local gotoTutorialButton = display.newImageRect( "img/gotoTutorial.png", 100, 50 )
	gotoTutorialButton.x = backgroundRect.x*3/2
	gotoTutorialButton.y = backgroundRect.y + backgroundRect.height/2 - gotoTutorialButton.height/2
	gotoTutorialButtonGroup = display.newGroup()
	gotoTutorialButtonGroup:insert( gotoTutorialButton )

	overlayGroup:insert( background )
	overlayGroup:insert( backgroundRect )
	overlayGroup:insert( gameText )
	overlayGroup:insert( skipButtonGroup )
	overlayGroup:insert( gotoTutorialButtonGroup )
	overlayGroup:toFront()
	sceneGroup:insert( overlayGroup )
end

--- Called twice, once BEFORE, and once immediately after scene has moved onscreen.
-- @tparam event event Event fired by the composer API.
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	local parent = event.parent
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
		function tutorialPressed( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				parent:gotoTutorial()
			end
		end

		function skipPressed( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				parent:skipButtonPressed()
			end
		end

		gotoTutorialButtonGroup:addEventListener( "touch", tutorialPressed )
		skipButtonGroup:addEventListener( "touch", skipPressed )
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
		gotoTutorialButtonGroup:removeEventListener( "touch", tutorialPressed )
		skipButtonGroup:removeEventListener( "touch", skipPressed )
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
