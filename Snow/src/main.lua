-- snow example

display.setStatusBar( display.HiddenStatusBar )

display.setDefault( "background", .05,.05,.2 )

local snowGroup = display.newGroup()

local function snowDrop( flake )
	if (flake == nil) then
		local flake = display.newCircle( snowGroup, 0, 0, 2 )
		flake:setFillColor( .9,.9,.9 )
		snowDrop( flake )
	else
		flake.x, flake.y = math.random( 0, display.actualContentWidth ), -10
		local xTarget, yTarget = math.random( 0, display.actualContentWidth ), display.actualContentHeight+10
		
		transition.to( flake, { x=xTarget, y=yTarget, delay=math.random( 0, 5000 ), time=math.random( 3000, 10000 ), tag="snow", onComplete=snowDrop } )
	end
end

for i=1, 50 do
	snowDrop()
end
