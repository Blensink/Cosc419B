--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local settings = require( "model.settingsModel" )
local backButtonGroup
local backButton
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
	print( "[COMPOSER]: Creating template" )

	local background = display.newImageRect( "img/questionBackground.png", display.contentHeight, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.alpha = 0.25
	sceneGroup:insert( background )

	-----------------------------------------------------------------------------
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	-----------------------------------------------------------------------------

	local creditsTextOptions = 
	{
	    --parent = textGroup,
	    text = "Game Design: Brendan Lensink \n	Art: Brendan Lensink \n	Sound Design: Brendan Lensink \n Puzzle Design: Brendan Lensink \n Sound Effects: Jessica Weeres",     
	    x = display.contentCenterX,
	    y = display.contentCenterY,
	    width = display.contentWidth - 50,
	    font = native.systemFontBold,   
	    fontSize = 18,
	    align = "center"  --new alignment parameter
	}

	local creditsText = display.newText( creditsTextOptions )
	creditsText:setFillColor( 0, 0, 0 )

	backButton = display.newImageRect( "img/back.png", 100, 50 )
	backButton:setFillColor( unpack(settings.getButtonOffColor() ) )
	backButton.x = display.contentWidth - 100
	backButton.y = display.contentHeight - 100

	backButtonGroup = display.newGroup()
	backButtonGroup:insert( backButton )

	sceneGroup:insert( creditsText )
	sceneGroup:insert( backButtonGroup ) 
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
		print( "[COMPOSER]: Will show template" )

		------------------------------------------------------------------------------
		-- Called when the scene is still off screen (but is about to come on screen).
		------------------------------------------------------------------------------

		local function backPressed( event)
			local phase = event.phase
				backButton:setFillColor( unpack(settings.getButtonOnColor() ) )
			if phase == "ended" then
				backButton:setFillColor( unpack(settings.getButtonOffColor() ) )				
				composer.gotoScene( "view.titleScene" )
			end
		end

		backButtonGroup:addEventListener( "touch", backPressed )

	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then
		print( "[COMPOSER]: Did show template" )

		-----------------------------------------------------------------------------
		-- Called when the scene is now on screen.
		-- Insert code here to make the scene come alive.
		-- Example: start timers, begin animation, play audio, etc.
		-----------------------------------------------------------------------------

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
		print( "[COMPOSER]: Will hide template" )

		-----------------------------------------------------------------------------
		-- Called when the scene is on screen (but is about to go off screen).
		-- Insert code here to "pause" the scene.
		-- Example: stop timers, stop animation, stop audio, etc.
		-----------------------------------------------------------------------------

	------------------------------------------------
	-- When the scene has finished moving offscreen.
	------------------------------------------------
	elseif ( phase == "did" ) then
		print( "[COMPOSER]: Did hide template" )

		-----------------------------------------------------------------------------
		-- Called immediately after scene goes off screen.
		-----------------------------------------------------------------------------

	end
end

--- Called prior to removal of scene's view (can be recycled or removed).
-- @tparam event event Event fired by the composer API.
function scene:destroy( event )
	local sceneGroup = self.view
	print( "[COMPOSER]: Destroying template" )

	-----------------------------------------------------------------------------
	-- Called prior to the removal of scene's view ("sceneGroup").
	-- Insert code here to clean up the scene.
	-- Example: remove display objects, save state, etc.
	-----------------------------------------------------------------------------

	backButtonGroup:removeEventListener( "touch", backPressed )

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