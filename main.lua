-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Declaring Variables
display.setStatusBar( display.HiddenStatusBar )
local widget = require( "widget" )
local canTap = true
taps = 1
multiplier= 1
auto = 1
local bg = display.newImageRect("bg@2x.png",360,570)
bg.x = display.contentWidth/2
bg.y = display.contentHeight/2
local diamond = display.newImage("diamond.png")
local x2p = display.newImage("x2.png")
local titleBar = display.newImage("titleBar.png")
local shopOpen = display.newImage("shop.png")
local shopClose = display.newImage("shopClose.png")
local shopBG = display.newImage("shopBG.png")
local total = display.newText( "0 Diamonds!", 0, 0, "kavoon", 18 ) -- native.systemFont
local perSecond = display.newText( "1 diamond per second!", 0, 0, "kavoon", 16 ) -- native.systemFont
local path = system.pathForFile( "diamonds.txt", system.ResourceDirectory )
local path2 = system.pathForFile( "multiplier.txt", system.ResourceDirectory )
local path3 = system.pathForFile( "auto.txt", system.ResourceDirectory )
local tapBox = display.newImage("tapbox.png")
local tapBox2 = display.newImage("tapbox.png")
local name = display.newText( "Power Click", 120, 0, "kavoon", 16 ) -- native.systemFont
name:setFillColor( 0, 0, 0 )
local cost = display.newText( "1000 Diamonds!", 120, 30, "kavoon", 14 ) -- native.systemFont
cost:setFillColor( 0, 0, 0 )
local level = display.newText( "Level: 0", 200, 0, "kavoon", 14 ) -- native.systemFont
level:setFillColor( 0, 0, 0 )
local what = display.newText( "Click: x2", 200, 30, "kavoon", 14 ) -- native.systemFont
what:setFillColor( 0, 0, 0 )
local scrollView = widget.newScrollView
{
	left = 40,
	top = 160,
	width = 240,
	height = 240,
	bottomPadding = 50,
	id = "onBottom",
	horizontalScrollDisabled = true,
	verticalScrollDisabled = false,
	listener = scrollListener,
	hideBackground=true,
}
-- Positioning images
total.x = 160
total.y = 55
shopClose.x = 175
shopClose.y = 70
shopOpen.x = 270
shopOpen.y = 435
shopOpen:scale(0.2,0.2)
perSecond.x = 160
perSecond.y = 80
titleBar:scale(0.5,0.57)
titleBar:translate(160,46)
diamond:scale(0.5,0.5)
diamond:translate(160,250)
shopBG:scale(0.25,0.25)
shopBG.x = display.contentWidth/2
shopBG.y = display.contentHeight/2 + 30
name.anchorY=0.0
level.anchorY=0.0
x2p:scale(0.15,0.15)
x2p.y=20
x2p.anchorX=0.0
tapBox.anchorY=0.0
tapBox.anchorX=0.0
tapBox2.y = 80
tapBox2.anchorX=0.0
-- Functions 

function tapBox:tap(event)
	if (taps > 999) then
	local file = io.open( path, "w" )
	local file2 = io.open( path2, "w" )
	multiplier = multiplier * 2
	taps = taps - 1000
	total.text = taps .. " Diamonds!"
	perSecond.text = multiplier .. " diamonds per tap!"
	file:write(taps)
	file2:write(multiplier)
	io.close(file)
	io.close(file2)
	file = nil
	file2 = nil
end
end

function diamond:touch(event)
    if (canTap) then
    	if event.phase == "began" then
			diamond:scale(0.9,0.9)
			local file = io.open( path, "w" )
		    taps = taps + multiplier + auto
		    total.text = taps .. " Diamonds!"
			file:write(taps)
			io.close(file)
			file = nil
		end
		if event.phase == "ended" or event.phase == "cancelled" then
			diamond = display.newImageRect("diamond.png", 202, 218)
			diamond:translate(160,250)
		end
	end
end

function GAoD()
	local file = io.open( path, "r" )
	if (file) then
		local savedData = file:read( "*a" )
	    total.text = savedData .. " Diamonds!"
		io.close(file)
		file = nil
		taps = tonumber(savedData)
	end
end

function GM()
	local file = io.open( path2, "r" )
	if (file) then 
		local savedData = file:read( "*a" )
		io.close(file)
		file = nil
		multiplier = tonumber(savedData)
	end
end

function GA()
	local file = io.open( path3, "r" )
	if (file) then 
		local savedData = file:read( "*a" )
	    perSecond.text = savedData .. " diamonds per second!"
		io.close(file)
		file = nil
		auto = tonumber(savedData)
	end
end

function shopClose:tap(event)
	shopClose.isVisible = false
	scrollView.isVisible = false
	shopBG.isVisible = false
	canTap = true
end

function shopOpen:tap(event)
	shopClose.isVisible = true	
	scrollView.isVisible = true
	shopBG.isVisible = true
	canTap = false
end


local function listener( event )
	if (canTap) then
		local file = io.open( path, "w" )
		taps = taps + auto
		total.text = taps .. " Diamonds!"
		file:write(taps)
		io.close(file)	
		file = nil
	    local y = timer.performWithDelay( 1000, listener )
	else
		local y = timer.performWithDelay( 1000, listener )
	end
end

-- The rest
scrollView:insert( name )
scrollView:insert( tapBox )
scrollView:insert( tapBox2 )
scrollView:insert(cost)
scrollView:insert(x2p)
scrollView:insert(level)
scrollView:insert(what)
scrollView.isVisible = false
shopClose.isVisible = false
shopBG.isVisible = false
GAoD()
GM()
GA()
shopOpen:addEventListener( "tap", shopOpen)
shopClose:addEventListener( "tap", shopClose)
diamond:addEventListener( "touch", diamond)
tapBox:addEventListener( "tap", tapBox)
local x = timer.performWithDelay( 1000, listener )

--Moving Items Smoothly
--function move(event)
--    if event.phase == "ended" then
--        transition.to(objectName, {time: 1000, x=event.x, y=event.y})
--    end
--end