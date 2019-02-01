-- shock absorber

-- http://developer.coronalabs.com/content/game-edition-collision-detection#Collision_categories_masking_and_groups
-- http://developer.coronalabs.com/content/game-edition-physics-joints#Piston_joint

local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid");
display.setDefault("fillColor", 135, 203, 105, 200)

local anchor = display.newCircle(-100,-100,10)
local terrain = display.newRect(0, 250, 480, 20)
local carBody = display.newRect(50, 50, 100, 50);
local shockFront = display.newRect(carBody.x + 25, carBody.y, 5, 25);
local shockBack = display.newRect(carBody.x - 35, carBody.y, 5, 25);
local wheelFront = display.newCircle(carBody.x + 30, carBody.y + 20, 20, 20);
local wheelBack = display.newCircle(carBody.x - 30, carBody.y + 20, 20, 20);

physics.addBody(anchor,"static")
physics.addBody(terrain, {density = 1.0, friction = 0.3, bounce = 0.2})
physics.addBody(carBody, {density = 1.0, friction = 0.3, bounce = 0, filter={groupIndex=-1}});
physics.addBody(shockFront, {density = 1.0, friction = 0.3, bounce = 0});
physics.addBody(shockBack, {density = 1.0, friction = 0.3, bounce = 0});
physics.addBody(wheelFront, {density = 1.0, friction = 4.0, bounce = 0.2, radius = 20, filter={groupIndex=-1}});
physics.addBody(wheelBack, {density = 1.0, friction = 4.0, bounce = 0.2, radius = 20, filter={groupIndex=-1}});

local groundweld = physics.newJoint("weld",anchor,terrain,terrain.x,terrain.y)
local shockFrontJoint = physics.newJoint("piston", carBody, shockFront, shockFront.x, shockFront.y, 0, 10);
local shockBackJoint = physics.newJoint("piston", carBody, shockBack, shockBack.x, shockBack.y, 0, 10);
local wheelFrontJoint = physics.newJoint("pivot", shockFront, wheelFront, wheelFront.x, wheelFront.y);
local wheelBackJoint = physics.newJoint("pivot", shockBack, wheelBack, wheelBack.x, wheelBack.y);

shockFrontJoint.isLimitEnabled = true
shockFrontJoint:setLimits( 5, 15 )

wheelFrontJoint.isMotorEnabled = true;
wheelFrontJoint.motorSpeed = 200;
wheelFrontJoint.maxMotorTorque = 100000;

shockBackJoint.isLimitEnabled = true
shockBackJoint:setLimits( 5, 15 )

wheelBackJoint.isMotorEnabled = true;
wheelBackJoint.motorSpeed = 200;
wheelBackJoint.maxMotorTorque = 100000;
