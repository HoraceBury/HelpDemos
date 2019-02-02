module(..., package.seeall)


-- returns the distance between points a and b
function lengthOf( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return math.sqrt(width*width + height*height)
end

-- converts degree value to radian value, useful for angle calculations
function convertDegreesToRadians( degrees )
--	return (math.pi * degrees) / 180
	return math.rad(degrees)
end

function convertRadiansToDegrees( radians )
	return math.deg(radians)
end

-- rotates a point around the (0,0) point by degrees
-- returns new point object
function rotatePoint( point, degrees )
	local x, y = point.x, point.y

	local theta = convertDegreesToRadians( degrees )

	local pt = {
		x = x * math.cos(theta) - y * math.sin(theta),
		y = x * math.sin(theta) + y * math.cos(theta)
	}

	return pt
end

-- rotates point around the centre by degrees
-- rounds the returned coordinates using math.round() if round == true
-- returns new coordinates object
function rotateAboutPoint( point, centre, degrees, round )
	local pt = { x=point.x - centre.x, y=point.y - centre.y }
	pt = rotatePoint( pt, degrees )
	pt.x, pt.y = pt.x + centre.x, pt.y + centre.y
	if (round) then
		pt.x = math.round(pt.x)
		pt.y = math.round(pt.y)
	end
	return pt
end

-- returns the degrees between (0,0) and pt
-- note: 0 degrees is 'east'
function angleOfPoint( pt )
	local x, y = pt.x, pt.y
	local radian = math.atan2(y,x)
	--print('radian: '..radian)
	local angle = radian*180/math.pi
	--print('angle: '..angle)
	if angle < 0 then angle = 360 + angle end
	--print('final angle: '..angle)
	return angle
end

-- returns the degrees between two points
-- note: 0 degrees is 'east'
function angleBetweenPoints( a, b )
	local x, y = b.x - a.x, b.y - a.y
	return angleOfPoint( { x=x, y=y } )
end

function angleOf( a, b )
	return math.atan2( b.y - a.y, b.x - a.x ) * 180 / math.pi
end

-- Extends the point away from or towards the origin to the length of len
function extrudeToLen( origin, point, len )
	local length = lengthOf( origin, point )
	local factor = len / length
	local x, y = (point.x - origin.x) * factor, (point.y - origin.y) * factor
	return x + origin.x, y + origin.y
end

-- returns the smallest angle between the two angles
-- ie: the difference between the two angles via the shortest distance
-- returned value is signed: clockwise is negative, anticlockwise is positve
-- returned value wraps at +/-180
function smallestAngleDiff( target, source )
	local a = target - source
	
	if (a > 180) then
		a = a - 360
	elseif (a < -180) then
		a = a + 360
	end
	
	return a
end

-- Returns the angle in degrees between the first and second points, measured at the centre
-- Always a positive value
function angleAt( centre, first, second )
	local a, b, c = centre, first, second
	local ab = lengthOf( a, b )
	local bc = lengthOf( b, c )
	local ac = lengthOf( a, c )
	local angle = math.deg( math.acos( (ab*ab + ac*ac - bc*bc) / (2 * ab * ac) ) )
	return angle
end

-- Returns true if the point is within the angle at centre measured between first and second
function isPointInAngle( centre, first, second, point )
	local range = angleAt( centre, first, second )
	local a = angleAt( centre, first, point )
	local b = angleAt( centre, second, point )
	-- print(range,a+b)
	return math.round(range) >= math.round(a + b)
end
