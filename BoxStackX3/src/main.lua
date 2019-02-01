require("physics")
physics.start()
physics.setGravity(0,9)
--physics.setDrawMode("hybrid")

local rows, columns = 7, 4

local colours = {
	-- indices here are named ...
	red={1,0,0},
	green={0,1,0},
	blue={0,0,1},
	yellow={1,1,0},
	
	-- indices from here are [1], [2], ...
	"red",
	"green",
	"blue",
	"yellow",
}

local ground = display.newRect( display.contentCenterX, display.contentCenterY+200, display.contentWidth, 100 )
physics.addBody( ground, "static", { friction=.3, bounce=.1 } )
ground.fill = {0,1,0}

local function getRndColour( ignoreIndex )
	local rnd = nil
	while (rnd == nil or rnd == ignoreIndex) do
		rnd = math.random( 1, 4 )
	end
	return colours[rnd]
end

local function genColumnColours()
	local rndcols = {}
	local initFirstIndex = math.random( 1, 3 )
	local initPrimaryColourIndex = math.random( 1, 4 )
	local initPrimaryColour = colours[ initPrimaryColourIndex ]
	
	-- fill table with non-primary colours
	for i=1, rows do
		rndcols[i] = getRndColour( initPrimaryColourIndex )
	end
	
	-- insert primary colour
	for i=initFirstIndex, initFirstIndex+4, 2 do
		rndcols[i] = colours[initPrimaryColour]
	end
	
	return rndcols
end

local function newBox( x, y, c )
	local rect = display.newRect( x, y, 50, 50 )
	rect.fill = c
	rect.strokeWidth = 1
	rect.stroke = {1,1,1}
	physics.addBody( rect, "dynamic", { friction=.3, bounce=.1, density=1 } )
	return rect
end

for r=1, rows do
	local colours = genColumnColours()
	for c=1, columns do
		local x, y = 200+r*50, ground.y-(c*50)-25
		newBox( x, y, colours[r] )
	end
end
