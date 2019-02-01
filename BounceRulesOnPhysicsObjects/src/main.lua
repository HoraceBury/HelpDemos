require("physics")
physics.start()
physics.setGravity(0,10)

local ground=display.newRect(  200, 600, 500, 20)
physics.addBody( ground, "static",{bounce=0} )

local r1=display.newRect(  100, 100, 50, 50)
physics.addBody( r1,"dynamic",{bounce=1} )

local r2=display.newRect( 200, 100, 50, 50)
physics.addBody( r2,"dynamic",{bounce=1} )