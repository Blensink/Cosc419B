--- A store item.
-- @element storeItem

storeItem = {}

local group
local image
local cost
local description
local imageName

--- Creates a new element.
-- @tparam[opt] table o A table of paramters in the format { paramName1 = paramValue1, paramName2 = paramValue2, ... }.
-- @treturn table The newly created element.
function storeItem:new ( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	o.image = display.newImageRect( o.imgName, 100, 100 )
	image = o.image
	imageName = o.imageName

	group = o.group
	group:insert( image )

	cost = o.cost
	description = o.description

	return o
end

return storeItem			