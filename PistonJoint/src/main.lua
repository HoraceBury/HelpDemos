-- piston demo

local physics = require("physics")
physics.start()
physics.setGravity(0,10)
physics.setDrawMode("hybrid")

local function createAnchor()
	local group = display.newGroup()
	group.x, group.y = 400, 900
	physics.addBody( group, "static", { radius=10, isSensor=true, density=10 } )
	return group
end

local function createPlatform()
	local group = display.newGroup()
	group.x, group.y = 400, 800
	local grass = display.newRect( group, 0, 0, 200, 25 )
	grass.fill = {0,1,0}
	physics.addBody( group, "dynamic", { bounce=.8, density=.1 } )
	return group
end

local function piston( anchor, platform )
	return physics.newJoint( "piston", anchor, platform, platform.x, platform.y, 1, 0 )
end

local function startPiston( pjoint )
	pjoint.isMotorEnabled = true
	pjoint.motorSpeed = 100
	pjoint.motorForce = 100
	pjoint.maxMotorForce = 10
end

local function dropBall( x, y )
	local group = display.newGroup()
	group.x, group.y = 400, 100
	local ball = display.newCircle( group, 0, 0, 50 )
	ball.fill = {0,0,1}
	physics.addBody( group, "dynamic", { radius=50, bounce=.8, density=.1 } )
	return group
end

local anchor = createAnchor()
local platform = createPlatform()
local joint = piston( anchor, platform )

dropBall()

startPiston( joint )
