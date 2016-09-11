--- A scene template.
-- Use the @scene tag for actual scenes.
-- @module scene

local composer = require( "composer" )
local scene = composer.newScene()

local session = require( "model.sessionModel" )
local settings = require( "model.settingsModel" )
local strings = require( "constants.strings" )

local backButton
local buyButton = nil
local equipButton = nil

local textGroup = display.newGroup()

local item
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
	item = params.object

	local background = display.newRect( display.contentCenterX, display.contentCenterY,
   display.contentWidth, display.contentHeight )
	background:setFillColor( { 0, 0, 0} )
	background.alpha = 0.3
	sceneGroup:insert( background )

	local backgroundRect = display.newRect( display.contentCenterX, display.contentCenterY,
    display.contentWidth - 50, display.contentHeight/2 )
	background:setFillColor( { 1, 1, 1 } )
	sceneGroup:insert( backgroundRect )

	local itemImage = display.newImageRect( item.imgName, 100, 100 )
	itemImage.x = display.contentCenterX
	itemImage.y = backgroundRect.y - backgroundRect.height/2 + itemImage.height/2 + 5
	sceneGroup:insert( itemImage )

	local textOptions =
	{
		text = strings.areYouSure .. string.lower( item.name ),
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = backgroundRect.width - 10,
		fontSize = 20,
		align = "center"
	}
	local text = display.newText( textOptions )
	text:setFillColor( 0, 0, 0 )
	text.y = itemImage.y + itemImage.height/2 + text.height/2 + 10
	textGroup:insert( text )

	local costOptions =
	{
		text = item.description,
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = backgroundRect.width - 10,
		fontSize = 16,
		align = "center"
	}
	local costText = display.newText( costOptions )
	costText:setFillColor( 0.2, 0.2, 0.2 )
	costText.y = text.y + text.height/2 + costText.height/2
	textGroup:insert( costText )

	local descriptionOptions =
	{
		text = strings.description1 .. item.cost .. this.description2,
		x = display.contentCenterX,
		y = display.contentCenterY,
		width = backgroundRect.width - 10,
		fontSize = 16,
		align = "center"
	}
	local description = display.newText( descriptionOptions )
	description:setFillColor( 0.2, 0.2, 0.2 )
	description.y = costText.y + costText.height/2 + description.height/2 + 10
	textGroup:insert( description )

	backButton = display.newImageRect( "img/back.png", 75, 50 )
	backButton.x = backgroundRect.x - backgroundRect.width/2 + backButton.width/2 + 5
	backButton.y = backgroundRect.y + backgroundRect.height/2 - backButton.height/2 - 5
	sceneGroup:insert( backButton )

	-- If they've already bought an item, show the equip option, otherwise show the buy button.
	if session:checkIfBought( item.name ) then
		-- This is two statements to capture non-equippable bought items.
		if item.type == "musicPack" or item.type == "theme" then
			equipButton = display.newImageRect( "img/equip.png", 75, 50 )
			equipButton.x = backgroundRect.x + backgroundRect.width/2 - equipButton.width/2 - 5
			equipButton.y = backgroundRect.y + backgroundRect.height/2 - equipButton.height/2 - 5
			textGroup:insert( equipButton )
		end
	else
		buyButton = display.newImageRect( "img/buy.png", 75, 50 )
		buyButton.x = backgroundRect.x + backgroundRect.width/2 - buyButton.width/2 - 5
		buyButton.y = backgroundRect.y + backgroundRect.height/2 - buyButton.height/2 - 5
		textGroup:insert( buyButton )
	end

	sceneGroup:insert( textGroup )
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

		function backPressed( event )
			local phase = event.phase

			if phase == "began" then
				backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				backButton:setFillColor( unpack( settings.getButtonOffColor() ) )
				composer.hideOverlay()
			end
		end

		backButton:addEventListener( "touch", backPressed )

		function buyPressed( event )
			local phase = event.phase

			if phase == "began" then
				backButton:setFillColor( unpack( settings.getButtonOnColor() ) )
			elseif phase == "ended" then
				backButton:setFillColor( unpack( settings.getButtonOffColor() ) )

				local currentPoints = session.getPoints()
				local cost = item.cost

				if currentPoints >= cost then
					if session:subtractPoints( cost ) then
						-- Item successfully bought.
						-- TODO: Add some fanfare here and write out the new settings.
						settings:setItemBought( item.name )
						settings:setActiveItem( item.type, item.name )
						composer.hideOverlay()
					else
						-- Just in case we somehow get this far and then the session model isn't able to subtract points.
						textGroup.alpha = 0

						local errorTextOptions =
						{
							text = strings.error,
							x = display.contentCenterX,
							y = display.contentCenterY,
							width = display.contentWidth - 50,
							fontSize = 20,
							align = "center"
						}
						local errorText = display.newText( errorTextOptions )
						errorText:setFillColor( 0, 0, 0)
						sceneGroup:insert( errorText )
						end
				else
					textGroup.alpha = 0

					local errorTextOptions =
					{
						text = strings.error,
						x = display.contentCenterX,
						y = display.contentCenterY,
						width = display.contentWidth - 50,
						fontSize = 20,
						align = "center"
					}
					local errorText = display.newText( errorTextOptions )
					errorText:setFillColor( 0, 0, 0)
					sceneGroup:insert( errorText )
				end
			end
		end

		function equipPressed( event )
			local phase = event.phase

			if phase == "began" then
			elseif phase == "ended" then
				session.setActiveItem( item.type, item.name )
				composer.hideOverlay()
			end
		end

		if equipButton ~= nil then
			equipButton:addEventListener( "touch", equipPressed )
		elseif buyButton ~= nil then
			buyButton:addEventListener( "touch", buyPressed )
		end
	--------------------------------------------------
	-- Immediately after the scene has moved onscreen.
	--------------------------------------------------
	elseif ( phase == "did" ) then
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
		backButton:removeEventListener( "touch", backPressed )

		if equipButton ~= nil then
			equipButton:removeEventListener( "touch", equipPressed )
		elseif buyButton ~= nil then
			buyButton:removeEventListener( "touch", buyPressed )
		end
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
