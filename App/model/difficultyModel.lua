--- Difficulty Model
-- Model to keep track of points earned finishing puzzles.
-- @module model
difficultyModel = {}

--- Add points based on how much time passed.
-- @param time The time taken.
-- @return The points added.
function difficultyModel:addPoints( time )
	if time <= 10 then
		return 3
	elseif time >= 10 and time <= 30 then
		return 2
	else
		return 1
	end
end

return difficultyModel
