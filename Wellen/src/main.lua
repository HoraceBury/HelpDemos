-- wellen

-- turn off status display bar
display.setStatusBar(display.HiddenStatusBar)

-- load libraries
local physics = require("physics")
local stage = display.getCurrentStage()

-- setup world
physics.start()
physics.setGravity(0,0)
physics.setDrawMode("hybrid")

-- environment setup
local circles = display.newGroup()
local initcount = 10

-- create an input bar
function createBar(index,title,callback,initval,min,max)
        local group = display.newGroup()
        group.y = index * 100
        local titletxt = display.newText(group,title, 0, 0, native.systemFont, 22)
        local numtext = display.newText(group,initval, 300, 0, native.systemFont, 22)
        local rect = display.newRoundedRect( group, 0, 0, 20, 50, 10 )
        rect.x, rect.y = display.contentWidth / (max-min) * initval, 50

        function touch(event)
                if (event.phase == "began") then
                        stage:setFocus(rect)
                elseif (event.phase == "ended" or event.phase == "cancelled") then
                        stage:setFocus(nil)
                end
                rect.x = event.x
                local val = event.x/(display.contentWidth/(max-min)) + min
                numtext.text = tostring(val)
                numtext.x = 300 + numtext.width/2
                callback(val)
                return true
        end
        rect:addEventListener("touch",touch)

        return group
end

-- change number of balls
function changeBalls(val)
        circles:removeSelf()
        circles = display.newGroup()
        createCircles(circles,math.floor(val))
end
createBar(0,"number of balls",changeBalls,10,2,100)

-- change length of distance joint
function changeLength(val)
        for i=1, circles.numChildren-1 do
                circles[i].joint.length = math.floor(val)
        end
end
createBar(1,"joint length",changeLength,display.contentWidth/initcount,5,100)

-- change distance joint frequency
function changeFrequency(val)
        for i=1, circles.numChildren-1 do
                circles[i].joint.frequency = math.floor(val)
        end
end
createBar(2,"joint frequency",changeFrequency,10,0,100)

-- change distance joint damping ratio
function changeRatio(val)
        for i=1, circles.numChildren-1 do
                circles[i].joint.dampingRatio = val
        end
end
createBar(3,"joint dampingRatio",changeRatio,0,0,1)

-- move circles
function touch(event)
        if (event.phase == "began") then
                stage:setFocus(event.target)
                event.target.joint = physics.newJoint("touch",event.target,event.x,event.y)
        elseif (event.phase == "moved") then
                event.target.joint:setTarget(event.x,event.y)
        else
                stage:setFocus(nil)
                event.target.joint:removeSelf()
                event.target.joint = nil
        end
end

-- deactivate a body
function tap(event)
        event.target.isBodyActive = not event.target.isBodyActive
end

-- build circles
function createCircles(circles,count)
        count = count + 1
        for i=0, count do
                local c = display.newCircle(circles, (display.contentWidth/count)*i, display.contentHeight/2+200, 25)
                c.isVisible = true
                c.isHitTestable = true
                if (i == 0 or i == count) then
                        physics.addBody(c,"static",{friction=0,density=1,bounce=0,radius=25})
                else
                        physics.addBody(c,"dynamic",{friction=0,density=1,bounce=0,radius=25})
                end
                if (i>0) then
                        local j = physics.newJoint("distance",
                                circles[i],circles[i+1],
                                circles[i].x,circles[i].y,
                                circles[i+1].x,circles[i+1].y)
                        circles[i].joint = j
                --[[
                        j.frequency = 0
                        j.length = 76
                        j.dampingRatio = 0
                ]]--
                end
                c:addEventListener( "touch", touch )
                c:addEventListener( "tap", tap )
        end
end

-- create balls
createCircles(circles,initcount)
