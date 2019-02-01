local physics = require ("physics")

physics.start()
physics.setGravity(0, 0)
physics.setDrawMode("hybrid")

--anchor object for the wheel
local anchor = display.newRect( 0, 0, 10, 10 )
anchor.x, anchor.y = 100, 100
physics.addBody(anchor,"static")

--wheel
local wheel = display.newCircle( 100, 100, 100 )
physics.addBody( wheel, "dynamic", {radius=100} )

--pivot joint anchored to the anchor object and joining to the wheel
local wheeljoint = physics.newJoint("pivot",anchor,wheel,100,100)

--piston bar
local bar = display.newRect( 0, 0, 300, 20 )
bar.x, bar.y = 250, 190
physics.addBody(bar,"dynamic",{filter={groupIndex=-1}})

--pivot joint joining the wheel to the piston bar
local barjoint = physics.newJoint("pivot",wheel,bar,bar.x-150,bar.y)

--pump object (moves left/right inside the canister)
local pump = display.newRect( 0, 0, 20, 18 )
pump.x, pump.y = 400, 190
physics.addBody(pump, "dynamic", {friction=0})

--pivot joint joining the piston bar to the pump object
local pumpjoint = physics.newJoint("pivot",bar,pump,pump.x,pump.y)

--a pair of fixed objects for the inside of the canister for the pump object to run between
local toprunner = display.newRect(0, 0, 300, 20)
local bottomrunner = display.newRect(0, 0, 300, 20)
toprunner.x, toprunner.y = 380, 80
bottomrunner.x, bottomrunner.y = 380, 120
physics.addBody(toprunner,"static",{filter={groupIndex=-1}})
physics.addBody(bottomrunner,"static",{filter={groupIndex=-1}})

-- finally, move the pump object into the canister so we avoid the messy maths
pump.y = 100
