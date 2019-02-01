-- scroll and drag item demo

local widget = require( "widget" )

function lengthOf( a, b )
    local width, height = b.x-a.x, b.y-a.y
    return (width*width + height*height)^0.5
end

stage = display.getCurrentStage()

-- Create a ScrollView
local scrollView = widget.newScrollView
{
    top = 0,
    left = 0,
    width = display.contentWidth,
    height = display.contentHeight/2,
    scrollWidth = display.contentWidth*5,
    scrollHeight = display.contentHeight,
    verticalScrollDisable = true,
}

local function dragItem(e)
	if (e.phase == "began") then
		stage:setFocus( e.target )
		e.target.hasFocus = true
		return true
	elseif (e.target.hasFocus) then
		if (e.phase == "moved") then
			local start = {x=e.xStart,y=e.yStart}
			if (lengthOf(start,e) > 10) then
				if (math.abs(e.y-e.yStart) > math.abs(e.x-e.xStart)) then
					-- vertical drag
					local dupe = e.target:duplicate(e)
				else
					-- horizontal drag
					scrollView:takeFocus(e)
				end
			end
		else
			setFocus(nil)
			e.target.hasFocus = false
		end
		return true
	end
	return false
end

local function duplicate( self, e )
	local grp = display.newGroup()
	grp.x, grp.y = e.x, e.y
	
	local circle = display.newCircle( grp, 0, 0, 75 )
	circle:setFillColor(255,0,0)
	
	local txt = display.newText( grp, self.txt.text, 0, 0, native.systemFont, 52 )
	txt.x, txt.y = 0, 0
	
	function grp:touch(e)
		if (e.phase == "began") then
			e.target.hasFocus = true
			stage:setFocus(e.target)
			return true
		elseif (e.target.hasFocus) then
			if (e.phase == "moved") then
				e.target.x, e.target.y = e.x, e.y
			else
				e.target.x, e.target.y = e.x, e.y
				stage:setFocus(nil)
				e.target.hasFocus = false
			end
			return true
		end
		return false
	end
	grp:addEventListener("touch",grp)
	
	stage:setFocus(grp)
	grp.hasFocus = true
	
	self.hasFocus = false
end

for i=1, 10 do
	local grp = display.newGroup()
	grp.x, grp.y = i*200, display.contentCenterY/2
	
	grp.duplicate = duplicate
	
	local circle = display.newCircle( grp, 0, 0, 75 )
	circle:setFillColor(255,0,0)
	
	grp.txt = display.newText( grp, i, 0, 0, native.systemFont, 52 )
	grp.txt.x, grp.txt.y = 0, 0
	
	scrollView:insert( grp )
	grp:addEventListener("touch",dragItem)
end
