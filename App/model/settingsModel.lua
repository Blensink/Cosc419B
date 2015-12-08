settingsModel = {}

local session = require( "model.sessionModel" )

local buttonOffColor = {102/255, 204/255, 255/255}
local buttonOnColor = {59/255, 78/255, 98/255}

function settingsModel:getButtonOffColor()
	return buttonOffColor
end

function settingsModel:getButtonOnColor()
	return buttonOnColor
end

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

--------------------------------------------------------------------------------
--                                                                            --
-- Store Related Settings.                                                    --
--                                                                            --
--------------------------------------------------------------------------------

function settingsModel:setItemBought( itemName )
	sessionModel:setItemBought( itemName )
	sessionModel:saveInfo()
end

function settingsModel:setActiveItem( type, name )
	sessionModel:setActiveItem( type, name )
	sessionModel:saveInfo()
end

return settingsModel
