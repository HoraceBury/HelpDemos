-- target physics demo

-- ref: http://stackoverflow.com/questions/1878907/the-smallest-difference-between-2-angles

require("physics")
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")

local mathlib = require("mathlib")

local stage = display.getCurrentStage()

local bulletspeed = 500

local function smallestAngle( target, source )
	local a = target - source
	return (a + 180) % 360 - 180
end

local function fireBullet( turret, touch )
	local group = display.newGroup()
	group.x, group.y = turret.x, turret.y
	group.name = "bullet"
	
	local directionangle = math.angleOf(turret,touch)
	
	local body = display.newRect( group, 0,0 , 30,10 ) -- replace this with an image
	group.rotation = directionangle
	
	physics.addBody( group, "dynamic" )
	group.isBullet = true
	
	local pt = math.rotateTo( {x=bulletspeed,y=0}, directionangle )
	group:setLinearVelocity( pt.x, pt.y )
	
	return group
end

local function newcannon( turret )
	local group = display.newGroup()
	group.x, group.y = turret.x, turret.y
	group.name = "cannon"
	
	local body = display.newRect( group, 50,0 , 50,10 ) -- replace this with an image
	body.fill = {1,.5,.5}
	
	function group:doFireBullet( turret, touch )
		-- 'doFire' can only be called from inside 'doFireBullet'
		local function doFire()
			-- then fire bullet
			fireBullet( turret, touch )
		end
		
		-- get angle to rotate by
		local angle = smallestAngle( math.angleOf(turret,touch), group.rotation )
		
		-- turn turret first
--		transition.to( group, { time=math.abs(angle*3), rotation=group.rotation+angle, onComplete=doFire } )
		transition.to( group, { time=(1000/180)*math.abs(angle), rotation=group.rotation+angle, onComplete=doFire } )
	end
	
	return group
end

local function newturret(x,y)
	local group = display.newGroup()
	group.x, group.y = x, y
	group.name = "turret"
	
	local circle = display.newCircle( group, 0, 0, 50 ) -- replace this with an image
	circle.fill = {1,0,0}
	
	local cannon = newcannon( group )
	
	function group:tap(e)
		cannon:doFireBullet( group, e )
		return true
	end
	Runtime:addEventListener("tap",group)
	
	return group
end

newturret( display.contentCenterX, display.contentCenterY )
