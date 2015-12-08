--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local session = require( "model.sessionModel" )

local overlayGroup = display.newGroup()
local rightButtonGroup
local leftButtonGroup
local status

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
	status = params.status

	-----------------------------------------------------------------------------
	-- Initialize the scene here.
	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	-----------------------------------------------------------------------------

	local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
	background:setFillColor( { 0, 0, 0} )
	background.alpha = 0.3

	local backgroundRect = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth - 50, display.contentHeight/3 )
	background:setFillColor( { 1, 1, 1 } )

	overlayGroup:insert( background )
	overlayGroup:insert( backgroundRect )

	local gameText
	-- We're going to display a different message/behaviour based on whther
	-- 0 = false, 1 = true, 2 = not done.
	if status == 0 then
		gameText = display.newImageRect( "img/gameOver.png", 200, 100 )
		gameText.x = backgroundRect.x
		gameText.y = backgroundRect.y - backgroundRect.height/2 + gameText.height*3/4

		rightButton = display.newImageRect( "img/tryagain.png", 100, 50 )
		rightButton.x = backgroundRect.x*3/2
		rightButton.y = backgroundRect.y + backgroundRect.height/2 - rightButton.height/2
		rightButtonGroup = display.newGroup()
		rightButtonGroup:insert( rightButton )
	elseif status == 1 then
		-- If this is a custom game, add some dollarydoos and show one path.
		if params.puzzleType == "custom" then
			session.getInfo()
			local currentPoints = session.getPoints()

			-- Add points based on how well they did.
			-- For now, dummy.
			local pointsEarned = params.amount
			print( "earned", pointsEarned)
			session:addPoints( pointsEarned )
			session.saveInfo()

			gameText = display.newImageRect( "img/correct.png", 200, 100 )
			gameText.x = backgroundRect.x
			gameText.y = backgroundRect.y - backgroundRect.height/2 + gameText.height/2 + 10
		
			local pointsTextOptions = 
			{
			    --parent = textGroup,
			    text = "You earned " .. pointsEarned .. " points!",
			    x = display.contentCenterX,
			    y = display.contentCenterY + 25,
			    width = display.contentWidth - 50,
			    font = native.systemFontBold,   
			    fontSize = 24,
			    align = "center"  --new alignment parameter
			}		
			local pointsText = display.newText( pointsTextOptions )
			pointsText:setFillColor( 0, 0, 0 )
			overlayGroup:insert( pointsText )

		else
			gameText = display.newImageRect( "img/correct.png", 200, 100 )
			gameText.x = backgroundRect.x
			gameText.y = backgroundRect.y - backgroundRect.height/2 + gameText.height*3/4
		end

		local rightButton = display.newImageRect( "img/next.png", 100, 50 )
		rightButton.x = backgroundRect.x*3/2
		rightButton.y = backgroundRect.y + backgroundRect.height/2 - rightButton.height/2
		rightButtonGroup = display.newGroup()
		rightButtonGroup:insert( rightButton )
	elseif status == 2 then
		gameText = display.newImageRect( "img/notDone.png", 200, 100 )
		gameText.x = backgroundRect.x
		gameText.y = backgroundRect.y - backgroundRect.height/2 + gameText.height*3/4

		local rightButton = display.newImageRect( "img/back.png", 100, 50 )
		rightButton.x = backgroundRect.x*3/2
		rightButton.y = backgroundRect.y + backgroundRect.height/2 - rightButton.height/2
		rightButtonGroup = display.newGroup()
		rightButtonGroup:insert( rightButton )
	end

	local leftButton = display.newImageRect( "img/home.png", 100, 50 )
	leftButton.x = backgroundRect.x/2
	leftButton.y = backgroundRect.y + backgroundRect.height/2 - leftButton.height/2
	leftButtonGroup = display.newGroup()
	leftButtonGroup:insert( leftButton )

	overlayGroup:insert( rightButtonGroup )
	overlayGroup:insert( leftButtonGroup )
	overlayGroup:insert( gameText )
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
		function rightPressed( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				if status == 0 then
					parent:restart()
				elseif status == 1 then
					parent:puzzleFinished()
				elseif status == 2 then
					composer.hideOverlay()
					audio.resume()
					transition.resume()
				end
			end
		end

		function leftPressed( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				parent:goHome()
			end
		end

		rightButtonGroup:addEventListener( "touch", rightPressed )
		leftButtonGroup:addEventListener( "touch", leftPressed )
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

		rightButtonGroup:removeEventListener( "touch", rightPressed )
		leftButtonGroup:removeEventListener( "touch", leftPressed )

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