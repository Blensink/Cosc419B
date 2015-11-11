--- An element template.
-- Use @element for actual elements.
-- @module element

element = {}

--- Creates a new element.
-- @tparam[opt] table o A table of paramters in the format { paramName1 = paramValue1, paramName2 = paramValue2, ... }.
-- @treturn table The newly created element.
function element:new ( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	return o
end

return element