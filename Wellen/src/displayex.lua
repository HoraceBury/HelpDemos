-- DISPLAY LIBRARY


-- provides a generic reference to the stage display group
stage = display.getCurrentStage()


-- regular indexOf method to find the index position of objects within a display group, returns nil or nf param if not found
display.indexOf = function( t, obj, nf )
	for i=1, t.numChildren do
		if (t[i] == obj) then
			return i
		end
	end
	if (nf) then
		return nf
	else
		return nil
	end
end
