-- WINDMILL
local physics = require("physics")
physics.start()
physics.setDrawMode( "hybrid" ) -- normal, hybrid, debug

local anchor = display.newCircle( 0,0,5 )
anchor.alpha = .1
physics.addBody( anchor, "static", { friction=0, bounce=0, density=0 } )

local hub = display.newCircle( display.contentCenterX, display.contentCenterY, 40 )
physics.addBody( hub, "dynamic", { friction=1, bounce=.1, density=3, radius=40 } )
hub.fixture = physics.newJoint( "pivot", anchor, hub, hub.x, hub.y )

local function tap( event )
	local ball = display.newCircle( event.x, event.y, 20 )
	physics.addBody( ball, "dynamic", { friction=1, bounce=.1, density=1, radius=20 } )
	
	function ball:timer( event )
		if (ball.y > 1500) then
			timer.cancel( ball.t )
			ball.t = nil            
			ball:removeSelf()        
		end
	end
	
	ball.t = timer.performWithDelay( 10000, ball, 3 )
end

local function addarm( hub, rot )
	arm = display.newRect( 0, 0, 20, 100 )    
	arm.x, arm.y = display.contentCenterX, display.contentCenterY - 80    
	physics.addBody( arm, "dynamic", { friction=1, bounce=.1, density=1 } )    
	arm.connect = physics.newJoint( "weld", hub, arm, hub.x, hub.y )    
	hub.rotation = hub.rotation + rot
end

for i=1, 4 do    
	addarm( hub, 90 )
end

hub.fixture.isMotorEnabled = true
hub.fixture.motorSpeed = 20
hub.fixture.maxMotorTorque = 40

Runtime:addEventListener( "tap", tap )

-- PENDULUM 
pend = display.newRect( 0, 0, 10, 100 )
pend.x, pend.y = 100, display.contentCenterY
physics.addBody( pend, "dynamic", { friction=1, bounce=.1, density=3 } )

pend.axis = physics.newJoint( "pivot", anchor, pend, pend.x, pend.y-pend.height/2 )
pend.axis.isMotorEnabled = true
pend.axis.motorSpeed = 20
pend.axis.maxMotorTorque = 40

function pend:timer( event )    
	if (pend.rotation > 50 or pend.rotation < -50) then        
		pend.axis.motorSpeed = 1 - pend.axis.motorSpeed
	end
end

pend.pulse = timer.performWithDelay( 500, pend, 0 )
