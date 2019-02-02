local pinchlibapi = require("pinchlib")

display.setStatusBar( display.HiddenStatusBar )
system.activate( "multitouch" )

--[[ There is no reason that the device environment could use display objects and stage:setFocus to track touch events... ]]--

--[[ This section handles the simulator interaction which is performed by display objects representing touches. ]]--

local suppressrotation = false
local suppressscaling = false

local stage = display.getCurrentStage()

local img = display.newImage( "yoda.png" )
img.x, img.y = display.contentCenterX, display.contentCenterY

local img2 = display.newImage( "yoda.png" )
img2.x, img2.y = display.contentCenterX, display.contentCenterY + 200

-- handles calling the pinch for simulator
function simPinch()
	local points = {}
	for i=1, stage.numChildren do
		if (stage[i].name == "touchpoint") then
			points[#points+1] = stage[i]
		end
	end
	pinchlibapi.doPinchZoom( img, points, suppressrotation, suppressscaling )
end

-- handles the simulator
function tap(event)
	local circle = display.newCircle(event.x, event.y, 25)
	circle.name = "touchpoint"
	circle.id = system.getTimer()
	circle.strokeWidth = 2
	circle:setStrokeColor(255,0,0)
	circle:setFillColor(0,0,255)
	circle.alpha = .6
	circle:addEventListener("tap", circle)
	circle:addEventListener("touch", circle)
	
	function circle:tap(event)
		circle:removeEventListener("tap",self)
		circle:removeEventListener("touch",self)
		circle:removeSelf()
		-- reset pinch data to avoid jerking the image when the average centre suddenly moves
		simPinch()
		return true
	end
	
	function circle:touch(event)
		if (event.phase == "began") then
			stage:setFocus(circle)
		elseif (event.phase == "moved") then
			circle.x, circle.y = event.x, event.y
		elseif (event.phase == "ended" or event.phase == "cancelled") then
			circle.x, circle.y = event.x, event.y
			stage:setFocus(nil)
		end
		
		simPinch()
		return true
	end
	
	simPinch()
	return true
end

--[[ This section handles device interaction which simply holds a list of the current touch events. ]]--

local touches = {}

-- handles calling the pinch for device
function devPinch( event, remove )
	-- look for event to update or remove
	for i=1, #touches do
		if (touches[i].id == event.id) then
			-- update the list of tracked touch events
			if (remove) then
				table.remove( touches, i )
			else
				touches[i] = event
			end
			-- update the pinch
			pinchlibapi.doPinchZoom( img, touches, suppressrotation, suppressscaling )
			return
		end
	end
	-- add unknown event to list
	touches[#touches+1] = event
	pinchlibapi.doPinchZoom( img, touches, suppressrotation, suppressscaling )
end

-- handles the device
function touch(event)
	if (event.phase == "began") then
		pinchlibapi.doPinchZoom( img,{}, suppressrotation, suppressscaling )
		devPinch( event )
	elseif (event.phase == "moved") then
		devPinch( event )
	else
		pinchlibapi.doPinchZoom( img,{}, suppressrotation, suppressscaling )
		devPinch( event, true )
	end
end

--[[ This section attaches the appropriate touch/tap handler for the environment (simulator or device). ]]--
-- Please note that the XCode simulator will be handled as 'device' although it has no way to provide multitouch events.

if (system.getInfo( "environment" ) == "simulator") then
	Runtime:addEventListener("tap",tap) -- mouse being used to create moveable touch avatars
elseif (system.getInfo( "environment" ) == "device") then
	Runtime:addEventListener("touch",touch) -- fingers being used to create real touch events
end
