difficultyModel = {}

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