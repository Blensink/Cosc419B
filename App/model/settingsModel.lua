settingsModel = {}

local buttonOffColor = {102, 204, 255}
local buttonOnColor = {59, 78, 98}

function settingsModel:getButtonOffColor()
	return buttonOffColor
end

function settingsModel:getButtonOnColor()
	return buttonOnColor
end

return settingsModel