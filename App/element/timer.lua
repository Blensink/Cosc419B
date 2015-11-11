--- A timer element.
-- @element Timer element for puzzles.
-- @module element

gameTimer = {}

local maxTime = 60
local timerGroup
local timerBar

--- Creates a new timer element.
-- @tparam[opt] table o A table of paramters in the format { paramName1 = paramValue1, paramName2 = paramValue2, ... }.
-- @treturn table The newly created element.
function gameTimer:new ( o )
	o = o or {}
	setmetatable( o, self )
	self.__index = self

	maxTime = o.maxTime

	timerGroup = o.timerGroup

	timerBar = display.newImageRect( "img/timerBar.png", o.width, o.height )
	timerBar.x = o.x
	timerBar.y = o.y

	timerGroup:insert( timerBar )

	return o
end

--- Start our timer and start moving our little man.
function gameTimer.start( timerDone )

print( "time started")
	local timerGuy = display.newImageRect( "img/timerGuy.png", 70, 70 )
	timerGuy.x = timerBar.x
	timerGuy.y = timerBar.y + timerBar.height/2
	timerGroup:insert( timerGuy )

	transition.to( timerGuy, 
		{ 
			time = maxTime*1000, 
			y = timerGuy.y - timerBar.height, 
			width = 15, 
			height = 15, 
			onComplete = function()
				local timerStar = display.newImageRect( "img/star.png", 5, 5 )
				timerStar.x = timerGuy.x
				timerStar.y = timerGuy.y

				display.remove( timerGuy )

				timerGroup:insert( timerStar )
				
				transition.to( timerStar, 
					{
						time = 300, 
						width = 75, 
						height = 75, 
						rotation = 90, 
						onComplete = function()
							transition.to( timerStar, 
								{ 
									time = 200,
									width = 0, 
									height = 0, 
									rotation = -90, 
									onComplete = function() 
										display.remove( timerStar )
										timerDone()
									end
								} 
							)
						end
					}
				)
			end
		}
	)
end

--- Get the max time specified earlier.
-- @treturn int The max time
function gameTimer:getMaxTime()
	return maxTime
end

function gameTimer:pause()
	transition.pause()
end

function gameTimer:resume()
	transition.resume()
end

return gameTimer					