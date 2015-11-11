--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

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
	local params = event.params

	-----------------------------------------------------------------------------
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	-----------------------------------------------------------------------------
	local overlayHole = display.newImageRect( "img/overlayWithHole.png", 1000, 1000 )
	overlayHole.x = display.contentCenterX + 104
	overlayHole.y = display.contentCenterY + 15
	overlayGroup:insert( overlayHole )

	local scientist = display.newImageRect( "img/scientistEyebrows.png", 150, 250 )
	scientist.xScale = -1
	scientist.x = scientist.width/2
	scientist.y = display.contentHeight - scientist.height/2 + 50
	overlayGroup:insert( scientist )

	local speechBubble = display.newImageRect( "img/speechBubble4.png", 300, 300 )
	speechBubble.x = display.contentWidth*2/3
	speechBubble.y = display.contentHeight*3/5 - 25
	overlayGroup:insert( speechBubble )

	local bigRedArrow = display.newImageRect( "img/bigRedArrow.png", 200, 100 )
	bigRedArrow.x = display.contentCenterX + 90
	bigRedArrow.y = display.contentHeight/4
	overlayGroup:insert( bigRedArrow )

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
		function overlayTap( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				parent:showOverlay5()
			end
		end
		overlayGroup:addEventListener( "touch", overlayTap )

				-- Last things last begin the music
		local backgroundMusic = audio.loadSound( "sound/story4.wav")
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