settingsModel = {}

local buttonOffColor = {102/255, 204/255, 255/255}
local buttonOnColor = {59/255, 78/255, 98/255}

function settingsModel:getButtonOffColor()
	return buttonOffColor
end

function settingsModel:getButtonOnColor()
	return buttonOnColor
end

return settingsModel