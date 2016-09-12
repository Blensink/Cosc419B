--- Settings Model
-- Model to keep track of app settingsModel
-- @module model
settingsModel = {}

local session = require( "model.sessionModel" )

local buttonOffColor = {102/255, 204/255, 255/255}
local buttonOnColor = {59/255, 78/255, 98/255}

--- Get the button off color.
-- @return The button off color.
function settingsModel:getButtonOffColor()
	return buttonOffColor
end

--- Get the button on color.
-- @return The button on color.
function settingsModel:getButtonOnColor()
	return buttonOnColor
end

--- Get the audio track.
-- @return The name of the audio track.
function settingsModel:getAudioTrack()
	local audio = session.getAudioTrack()

	if audio ~= nil then
		if audio == "No Music" then
			return nil
		elseif audio == "Alternate music pack #2" then
			return "sound/elevatormusic1.wav" --TODO: add new music pack here.
		else
			return "sound/elevatormusic1.wav"
		end
	else
		return "sound/elevatormusic1.wav"
	end
end

----------------------------------------------------------------------------------------------------
-- Store related settings
----------------------------------------------------------------------------------------------------

--- Set an item as bought.
-- @param itemName The item name.
function settingsModel:setItemBought( itemName )
	sessionModel:setItemBought( itemName )
	sessionModel:saveInfo()
end

--- Set an item as active.
-- @param type The type of item to set.
-- @param name The name of the item.
function settingsModel:setActiveItem( type, name )
	sessionModel:setActiveItem( type, name )
	sessionModel:saveInfo()
end

return settingsModel
