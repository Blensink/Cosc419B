--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local json = require( "json" )

local composer = require( "composer" )
local scene = composer.newScene()

local session = require( "model.sessionModel" )
local analytics = require( "model.analyticsModel" )
local settings = require( "model.settingsModel")

local object = require( 'element.object' )

local doneButtonGroup
local backButtonGroup 

local doneButton
local backButton 

local iconArea
local leftArrow
local rightArrow

local pageTable = {}
local currentPage = 1
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

		local backgroundImage = display.newImageRect( "img/questionBackground.png", display.contentHeight, display.contentHeight )
		backgroundImage.x = display.contentCenterX
		backgroundImage.y = display.contentCenterY
		backgroundImage.alpha = 0.2
		sceneGroup:insert( backgroundImage )

		backButton = display.newImageRect( "img/back.png", 100, 50 )
		backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
		backButton.x = backButton.width/2 + 20
		backButton.y = backButton.height/2 + 20

		backButtonGroup = display.newGroup()
		backButtonGroup:insert( backButton )
		sceneGroup:insert( backButtonGroup )

		doneButton = display.newImageRect( "img/done.png", 100, 50 )
		doneButton:setFillColor( unpack( settings.getButtonOffColor() ) )
		doneButton.x = display.contentWidth - doneButton.width/2 - 20
		doneButton.y = doneButton.height/2 + 20

		doneButtonGroup = display.newGroup()
		doneButtonGroup:insert( doneButton )
		sceneGroup:insert( doneButtonGroup )

		-- Create the answer areas.
		array1Area = display.newImageRect( "img/array.png", 150, 200 )
		array1Area.x = display.contentWidth/4
		array1Area.y = display.contentHeight - array1Area.height/2 - 10
		sceneGroup:insert( array1Area )

		array2Area = display.newImageRect( "img/array.png", 150, 200 )
		array2Area.x = display.contentWidth*3/4
		array2Area.y = display.contentHeight - array1Area.height/2 - 10
		sceneGroup:insert( array2Area )

		-- Create the icon area
		iconArea = display.newRect( display.contentCenterX, display.contentCenterY - 100, display.contentWidth - 50, 200 )
		iconArea:setFillColor( 0.5, 0.5, 0.5 )
		iconArea.alpha = 0.3
		sceneGroup:insert( iconArea )

		-- Create the left and right arrows to scroll.
		leftArrow = display.newImageRect( "img/bigRedArrow.png", 75, 35 )
		leftArrow.x = iconArea.x - iconArea.width/2 + leftArrow.width/2
		leftArrow.y = iconArea.y + iconArea.height/2 + leftArrow.height/2
		sceneGroup:insert( leftArrow )

		rightArrow = display.newImageRect( "img/bigRedArrow.png", 75, 35 )
		rightArrow.x = iconArea.x + iconArea.width/2 - rightArrow.width/2
		rightArrow.y = iconArea.y + iconArea.height/2 + rightArrow.height/2
		rightArrow:scale( -1, 1)
		sceneGroup:insert( rightArrow )

		-- Create the 'pages' of icons to display.
		-- We're going to do this in groups of 12, 3 rows of 4 per page.
		-- First step: get the list of all the icons available.
		local icons = session.getIconPack()

		-- Then make enough pages for all the icons.
		pageCount = math.floor( #icons/12 )
		for i=0,pageCount do
			local page = display.newGroup()
			table.insert( pageTable, page )
		end

		-- Aaand insert our icons.
		for index, path in pairs(icons) do
			local xOrigin = iconArea.x - iconArea.width/2 + 35
			local yOrigin = iconArea.y - iconArea.height/2 + 35
			local xPos = index % 4
			local yPos = index % 12
			local pageIndex = math.floor(index/12.000001) + 1 -- HACK: This will be a problem if there a lot of icons.

			-- This is stupid but can't think of a better way.
			if xPos == 0 then
				xPos = 4
			end

			if yPos == 0 then
				yPos = 12
			end

			if yPos <= 4 then
				row = 0
			elseif yPos >= 4 and yPos <= 8 then
				row = 1
			else 
				row = 2
			end

			local newObject = object:new( { imgName = "img/"..path, width = 50, height = 50, answer = "1", group = display.newGroup() } )
			newObject.group.x = xOrigin + 65*( xPos-1 )
			newObject.group.y = yOrigin + 65*row
			table.insert( pageTable[pageIndex], newObject.group )
			objectTable[newObject.group] = newObject
			sceneGroup:insert( newObject.group )
		end

		-- Finally set the alpha on all the pages but the first one to 0.
		for k,v in pairs( pageTable ) do
			for i,j in pairs( v ) do
				if k ~= 1 and type(i) == "number" then
					j.alpha = 0
				end
			end
		end

	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then

		function doneTouched( event )
			local phase = event.phase

			if phase == "began" then
				doneButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				-- TODO: Add a confirm action here.

				-- Hoo boy, here we go.
				-- Step 1: Loop through our array of objects and decide
				-- 	which ones were placed into each answer area.
				local newPuzzle = {}
				local answer

				for group, object in pairs( objectTable ) do
					if self:objectInArea( group, array1Area ) then
						-- Cut out the 'img/' and '.png' pieces
						str = object.imgName:sub( 5, string.len(object.imgName) - 4 )

						local newAnswer = {}
						table.insert( newAnswer, str )
						table.insert( newAnswer, 1 )
						table.insert( newPuzzle, newAnswer )

					elseif self:objectInArea( group, array2Area )  then
						-- Cut out the 'img/' and '.png' pieces
						str = object.imgName:sub( 5, string.len(object.imgName) - 4 )

						local newAnswer = {}
						table.insert( newAnswer, str )
						table.insert( newAnswer, 2 )
						table.insert( newPuzzle, newAnswer )
					end
				end

				session:writeLevel( newPuzzle )

				composer.gotoScene( "view.customGameScene" )
			end
		end

		function backTouched( event )
			local phase = event.phase

			if phase == "began" then
				backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				-- TODO: Add a confirm action here.
				composer.gotoScene( "view.customGameScene")
			end
		end

		function leftArrowPressed( event )
			if currentPage > 1 then
				currentPage = currentPage - 1

				for i = 1, #pageTable do
					if i == currentPage then
						for k,v in pairs( pageTable[i] ) do
							if type(k) == 'number' then
								v.alpha = 1
							end
						end
					else
						for k,v in pairs( pageTable[i] ) do
							if type(k) == 'number' then
								v.alpha = 0
							end
						end
					end
				end
			end
		end

		function rightArrowPressed( event )
			if currentPage < #pageTable then
				currentPage = currentPage + 1

				for i = 1, #pageTable do
					print( i, currentPage, #pageTable[i] )
					if i == currentPage then
						for k,v in pairs( pageTable[i] ) do
							if type(k) == "number" then
								v.alpha = 10
							end
						end
					else
						for k,v in pairs( pageTable[i] ) do
							if type(k) == 'number' then
								v.alpha = 0
							end
						end
					end
				end
			end
		end

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

				leftArrow:removeEventListener( "touch", leftArrowPressed )
				rightArrow:removeEventListener( "touch", rightArrowPressed )
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

				leftArrow:addEventListener( "touch", leftArrowPressed )
				rightArrow:addEventListener( "touch", rightArrowPressed )	

				-- If the button press ends and the button is outside of the starting area,
				--	remove it from the page group so it doesn't disappear on page change.
				if not self:objectInArea( event.target, iconArea ) then
					for k,v in pairs( pageTable[currentPage] ) do
						if v == event.target then
							pageTable[currentPage][k] = display.newGroup()
						end

					end
				end 
			end
		end

		for key, object in pairs( objectTable ) do
			object.group:addEventListener( "touch", objectTouched )
		end

		doneButton:addEventListener( "touch", doneTouched )
		backButton:addEventListener( "touch", backTouched )
		leftArrow:addEventListener( "touch", leftArrowPressed )
		rightArrow:addEventListener( "touch", rightArrowPressed )
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
		audio.stop()
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

function scene:objectInArea( group, area )
	if ( math.abs( group.x - area.x ) < area.width/2 and math.abs( group.y - area.y ) < area.height/2 ) then
		return true
	else
		return false
	end			
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