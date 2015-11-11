--- A game object.
-- @element object.
-- @module element

object = {}

local group
local answer
local aimage

--- Creates a new element.
-- @tparam[opt] imgName, height, width, answer
-- @treturn table The newly created element.
function object:new ( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	group = o.group
	o.image = display.newImageRect( o.imgName, o.width, o.height )
	aimage = o.image
	group:insert( aimage )

	local answer = o.answer

	return o
end

return object