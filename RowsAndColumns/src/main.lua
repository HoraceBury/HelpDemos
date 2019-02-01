local columnCount = 25

local cellWidth = display.actualContentWidth / columnCount
local cellHeight = cellWidth

local rowCount = math.ceil( display.actualContentHeight / cellHeight )

for x=0, columnCount do
  display.newLine( x*cellWidth,0 , x*cellWidth,display.actualContentHeight ).strokeWidth = 2
end
for y=0, rowCount do
  display.newLine( 0,y*cellHeight , display.actualContentWidth,y*cellHeight ).strokeWidth = 2
end

Runtime:addEventListener( "touch", function(e)
  local c = math.floor( e.x / cellWidth ) + 1
  local r = math.floor( e.y / cellHeight ) + 1
  print( "Column: "..c, "   Row: "..r )
end )
