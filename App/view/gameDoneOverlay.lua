--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local homeButtonGroup
local againButtonGroup
local overlayGroup = display.newGroup()
local againButton
local homeButton

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

	local gameText = display.newImageRect( "img/gameOver.png", 200, 100 )
	gameText.x = backgroundRect.x
	gameText.y = backgroundRect.y - backgroundRect.height/2 + gameText.height*3/4

	againButton = display.newImageRect( "img/again.png", 100, 50 )
	againButton:setFillColor( unpack( settings.getButtonOnColor() ) )
	againButton.x = backgroundRect.x*3/2
	againButton.y = backgroundRect.y + backgroundRect.height/2 - againButton.height/2
	againButtonGroup = display.newGroup()
	againButtonGroup:insert( againButton )

	homeButton = display.newImageRect( "img/home.png", 100, 50 )
	homeButton:setFillColor( unpack( settings.getButtonOnColor() ) )
	homeButton.x = backgroundRect.x/2
	homeButton.y = backgroundRect.y + backgroundRect.height/2 - homeButton.height/2
	homeButtonGroup = display.newGroup()
	homeButtonGroup:insert( homeButton )

	overlayGroup:insert( background )
	overlayGroup:insert( backgroundRect )
	overlayGroup:insert( gameText )
	overlayGroup:insert( againButtonGroup )
	overlayGroup:insert( homeButtonGroup )
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
		function homePressed( event )
			local phase = event.phase
			homeButton:setFillColor( unpack( settings.getButtonOnColor() ) )

			if phase == "began" then
			elseif phase == "ended" then
				storyButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				parent:goHome()
			end
		end

		function againPressed( event )
			local phase = event.phase
			againButton:setFillColor( unpack( settings.getButtonOnColor() ) )

			if phase == "began" then
			elseif phase == "ended" then
				storyButton:setFillColor( unpack( settings.getButtonOffColor() ) )
			end
		end

		homeButtonGroup:addEventListener( "touch", homePressed )
		againButtonGroup:addEventListener( "touch", againPressed )
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
		homeButtonGroup:removeEventListener( "touch", homePressed )
		againButtonGroup:removeEventListener( "touch", againPressed )
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
