--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local sessionModel = require( "model.sessionModel" )
local analytics = require( "model.analyticsModel" )
local object = require( "element.object" )
local gameTime = require( "element.timer" )
local settings = require( "model.settingsModel" )
local gameTimer

local object1

local doneButton
local array1Area
local array2Area

local objectOriginX = display.contentWidth/6
local objectOriginY = display.contentHeight/4
local objectTable = {}

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
	analytics:init()
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
		local background = display.newImageRect( "img/questionBackground.png", display.contentHeight,
      display.contentHeight )
		background.x = display.contentCenterX
		background.y = display.contentCenterY
		background.alpha = 0.25
		sceneGroup:insert( background )

		-- Create the answer areas.
		array1Area = display.newImageRect( "img/array.png", 150, 200 )
		array1Area.x = display.contentWidth/4
		array1Area.y = display.contentHeight - array1Area.height/2 - 10
		sceneGroup:insert( array1Area )

		array2Area = display.newImageRect( "img/array.png", 150, 200 )
		array2Area.x = display.contentWidth*3/4
		array2Area.y = display.contentHeight - array1Area.height/2 - 10
		sceneGroup:insert( array2Area )

		-- Create our done button
		doneButton = display.newImageRect( "img/done.png", 100, 50 )
		doneButton:setFillColor( unpack( settings.getButtonOffColor() ) )
		doneButton.x = display.contentCenterX
		doneButton.y = doneButton.height/2 + 10
		sceneGroup:insert( doneButton )

		gameTimer = gameTime:new
		{
			timerGroup = display.newGroup(),
			maxTime = 5000,
			width = 30,
			height = 300,
			x = display.contentWidth - 50,
			y = display.contentCenterY - 100
		}
		sceneGroup:insert( gameTimer.timerGroup )

		gameTimer.start( function()
			local puzzleDoneOptions =	{ params = { status = 0 } }
			composer.showOverlay( "view.puzzleDoneOverlay", puzzleDoneOptions )
		end )
		transition.pause()

		------------------------------------------------------------------------------
		-- Called when the scene is still off screen (but is about to come on screen).
		------------------------------------------------------------------------------
		sessionModel.getInfo()
		local levelInfo = sessionModel:getLevel("tutorial")

		-- Now that we know what our level is going to look like make the objects for it.
		for key, puzzleObject in pairs(levelInfo) do
			local objectImage = puzzleObject[1]
			local puzzleAnswer = puzzleObject[2]

			local xModifier = (key-1)%4
			local yModifier = math.floor( (key-1)/4 )

			local newObject = object:new( { imgName = "img/"..objectImage..".png", width = 50,
        height = 50, answer = puzzleAnswer, group = display.newGroup() } )
			newObject.group.x = objectOriginX + 60*xModifier
			newObject.group.y = objectOriginY + 60*yModifier

			-- Save this for our tutorial animation
			if key == 1 then
				object1 = newObject.group
			end

			objectTable[newObject.group] = newObject
			sceneGroup:insert( newObject.group )
		end
	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

		function objectTouched( event )
			local phase = event.phase
			local target = event.target

			if phase == "began" then
				objectTable[event.target].image.width = target.width + 10
				objectTable[event.target].image.height = target.height + 10

				event.target:toFront()
				for group, object in pairs( objectTable ) do
					if not( event.target == group ) then
						object.group:removeEventListener( "touch", objectTouched )
					end
				end
			elseif phase == "moved" then
				target.x = event.x
				target.y = event.y
			elseif phase == "ended" then
				objectTable[event.target].image.width = target.width - 10
				objectTable[event.target].image.height = target.height - 10

				for group, object in pairs( objectTable ) do
					if not( event.target == group ) then
						object.group:addEventListener( "touch", objectTouched )
					end
				end
			end
		end

		function doneTouched( event )
			local phase = event.phase
			local target = event.target

			-- Pause whatever's going on with the timer
			gameTimer.pause()

			-- 0 = false, 1 = true, 2 = not done.
			local puzzleCorrect = 1

			if phase == "began" then
				doneButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				doneButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				-- First check if our answers are in the right boxes.
				local area1Answer
				local area2Answer
				for key, object in pairs( objectTable ) do
					-- Decide which array the first element is to check the rest against.
          -- This means they're in area 1.
					if ( math.abs( object.group.x - array1Area.x ) < array1Area.width/2 and
              math.abs( object.group.y - array1Area.y ) < array1Area.height/2 ) then
						if area1Answer == nil then
							area1Answer = object.answer
						elseif not(area1Answer == object.answer) then
							puzzleCorrect = 0
							local wrongSound = audio.loadSound( "sound/femalewrong.wav")
							local onWrongSound = audio.play( wrongSound )
						end

					-- This means they're in area 2.
					elseif ( math.abs( object.group.x - array2Area.x ) < array2Area.width/2 and
              ( math.abs( object.group.y - array2Area.y ) < array2Area.height/2 ) )  then
						if area2Answer == nil then
							area2Answer = object.answer
						elseif not(area2Answer == object.answer) then
							puzzleCorrect = 0
							local wrongSound = audio.loadSound( "sound/femalewrong.wav")
							local onWrongSound = audio.play( wrongSound )
						end
					else
						puzzleCorrect = 2
						local wrongSound = audio.loadSound( "sound/femalewrong.wav")
						local onWrongSound = audio.play( wrongSound )
					end
				end

				if puzzleCorrect == 1 then
					local wrongSound = audio.loadSound( "sound/malehooray.wav")
					local onWrongSound = audio.play( wrongSound )
				end

				analytics.tutorialCompleted()
				local puzzleDoneOptions =
				{
					params =
					{
						status = puzzleCorrect
					}
				}
				composer.showOverlay( "view.puzzleDoneOverlay", puzzleDoneOptions )
			end
		end

		-- Log that the tutorial has been started
		analytics:tutorialStarted()

		-- Now the tutorial stuff.
		composer.showOverlay( "view.tutorial.overlay1")
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

		for key, object in pairs( objectTable ) do
			object.group:removeEventListener( "touch", objectTouched )
		end
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

function scene:showOverlay2()
	composer.hideOverlay()
	composer.showOverlay( "view.tutorial.overlay2" )
end

function scene:showOverlay3()
	composer.hideOverlay()
	composer.showOverlay( "view.tutorial.overlay3" )
end

function scene:showOverlay4()
	composer.hideOverlay()
	composer.showOverlay( "view.tutorial.overlay4" )
end

function scene:showOverlay5()
	composer.hideOverlay()
	composer.showOverlay( "view.tutorial.overlay5" )
end

function scene:showOverlay6()
	composer.hideOverlay()
	composer.showOverlay( "view.tutorial.overlay6" )
end


function scene:endTutorial()
	composer.hideOverlay()
	local sceneGroup = self.view

	-- First show the speech bubble.
	local finalSpeechBubble = display.newImageRect( "img/speechBubble7.png", 250, 250 )
	finalSpeechBubble.x = display.contentWidth - finalSpeechBubble.width/2 + 50
	finalSpeechBubble.y = display.contentCenterY
	sceneGroup:insert( finalSpeechBubble )

	local scientist = display.newImageRect( "img/scientistEyebrows.png", 150, 250 )
	scientist.x = display.contentWidth - scientist.width/2
	scientist.y = display.contentHeight - scientist.height/2 + 50
	sceneGroup:insert( scientist )

	local hand = display.newImageRect( "img/pointyHand.png", 50, 50 )
	hand.x = display.contentCenterX
	hand.y = scientist.y
	sceneGroup:insert( hand )

	-- Last things last begin the music
	local backgroundMusic = audio.loadSound( "sound/story7.wav")
	local backgroundMusicPlaying = audio.play( backgroundMusic, { fadein = 1000 } )

	transition.to( hand,
		{
			time = 1000,
			x = object1.x + 25,
			y = object1.y + 25,
			onComplete = function()
				object1.width = object1.width + 10
				object1.height = object1.height + 10

				transition.to( hand,
					{
						time = 1000,
						x = display.contentWidth/4 + 15,
						y = display.contentHeight - array1Area.height/2 + 10
					}
				)

				transition.to( object1,
					{
						time = 1000,
						x = display.contentWidth/4,
						y = display.contentHeight - array1Area.height/2 - 10,
						onComplete = function()
							object1.width = object1.width - 10
							object1.height = object1.height - 10
							finalSpeechBubble:removeSelf()

							local finalFinalSpeechBubble =
                display.newImageRect( "img/speechBubble8.png", 250, 250 )
							finalFinalSpeechBubble.x = display.contentWidth - finalFinalSpeechBubble.width/2 + 50
							finalFinalSpeechBubble.y = display.contentCenterY
							sceneGroup:insert( finalFinalSpeechBubble )

							timer.performWithDelay( 2000, function()
								hand:removeSelf()
								scientist:removeSelf()
								finalFinalSpeechBubble:removeSelf()
								transition.resume()
								end
							)

							-- Last add the event listeners
							doneButton:addEventListener( "touch", doneTouched)

							-- Last things last begin the music
						local backgroundMusic = audio.loadStream( "sound/elevatormusic1.wav")
						local backgroundMusicPlaying =
                audio.play( backgroundMusic, { loops = -1, fadein = 1000 } )
							for key, object in pairs( objectTable ) do
								object.group:addEventListener( "touch", objectTouched )
							end
						end
					}
				)
			end
		}
	)

end

function scene:goHome()
	sessionModel:setTutorialComplete()

	composer.gotoScene( "view.titleScene" )
end

function scene:puzzleFinished ()
	sessionModel:setTutorialComplete()

	composer.gotoScene( "view.titleScene" )
end

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
