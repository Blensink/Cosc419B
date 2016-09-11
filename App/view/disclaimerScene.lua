--- Disclaimer Scene.
-- @scene Disclaimer Scene
-- This will only show the first time a user opens the app, and will require
-- the user to consent to information being gathered about them for educational
-- purposes.

local composer = require( "composer" )
local scene = composer.newScene()
local sessionModel = require( "model.sessionModel" )
local settings = require( "model.settingsModel" )
local strings = require("constants.strings")

local disclaimerButtonGroup
local disclaimerButton

----------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
----------------------------------------------------------------------------------------------------
-- local forward references should go here

----------------------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
----------------------------------------------------------------------------------------------------

--- Composer functions.
-- Standard event handlers that are called by the Composer API when changing scenes.
-- @section composer

--- Called when the scene's view does not exist.
-- @tparam event event Event fired by the composer API.
function scene:create( event )
	local sceneGroup = self.view

	local background = display.newImageRect( "img/questionBackground.png",
    display.contentHeight, display.contentHeight )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	background.alpha = 0.25
	sceneGroup:insert( background )

	local disclaimerTextOptions =
	{
	    text = strings.disclaimer,
	    x = display.contentCenterX,
	    y = display.contentCenterY,
	    width = display.contentWidth - 50,
	    font = native.systemFontBold,
	    fontSize = 24,
	    align = "center"
	}

	local disclaimerText = display.newText( disclaimerTextOptions )
	disclaimerText:setFillColor( 0, 0, 0 )

	disclaimerButton = display.newImageRect( "img/okay.png", 100, 50 )
	disclaimerButton:setFillColor( unpack{ 0.95, 0.95, 0.95 } )
	disclaimerButton.x = display.contentCenterX
	disclaimerButton.y = disclaimerText.y + 100
	disclaimerButton:setFillColor( unpack(settings.getButtonOffColor() ) )

	disclaimerButtonGroup = display.newGroup()
	disclaimerButtonGroup:insert( disclaimerButton )

	sceneGroup:insert( disclaimerText )
	sceneGroup:insert( disclaimerButtonGroup )
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
		local function disclaimerPressed( event)
			local phase = event.phase

			if phase == "began" then
				disclaimerButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				disclaimerButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				sessionModel.seenDisclaimer()
				sessionModel.saveInfo()
				composer.gotoScene( "view.titleScene" )
			end
		end

		disclaimerButtonGroup:addEventListener( "touch", disclaimerPressed )

		-- Load in our session model, and all the info that comes with it.
		-- Check if they've already said yes to this, if so just skip all this business
		sessionModel.getInfo()
		if sessionModel.hasSeenDisclaimer() then
			composer.gotoScene( "view.titleScene" )
		end


	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

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
	disclaimerButtonGroup:removeEventListener( "touch", disclaimerPressed )

end

--- Custom functions.
-- Custom functions that provide additional functionality and are called from this Scene or its
-- associated controller.
-- @section custom

----------------------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
----------------------------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
