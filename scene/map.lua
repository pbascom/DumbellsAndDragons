--[[
		Initial Declarations
--]]


-- Requirements
local sceneName = "map"
local composer = require "composer"
local widget = require "widget"
local fn = require "lib.fn"
local raleway, unifraktur = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf"
local raleway_bold = "assets/font/Raleway 700.ttf"



-- Scene Variables
local scene = composer.newScene()
local background, midground, foreground, interface
local map, mbutton, uibutton, uiTray, uiTrayShadow

local view, phase, params

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local mbw, ubw = 60, width/4.5 -- Map button width, UI button width
local ubp = (width-4*ubw)/5 -- UI button padding

function getGoTo( scene, options )
	function goTo( event )
		composer.gotoScene( "scene." .. scene, options )
	end
	return goTo
end

--[[
		Creation Phase
--]]

function scene:create( event )

	-- Parent View
	view, params = self.view, event.params

	-- Content layers
	background = display.newGroup()
	view:insert( background )

	midground = display.newGroup()
	view:insert( midground )

	foreground = display.newGroup()
	view:insert( foreground )

	interface = display.newGroup()
	view:insert( interface )
	interface.x, interface.y = xn-width/2, yn-height/2 --Letterbox correction


	-- Content
	map = display.newImageRect( background, "assets/img/map.jpg", 480, 640 )
	map.x = xn; map.y = yn

	mbutton = {

		stair = widget.newButton({
			width = mbw,
			height = mbw,
			x = xn+85,
			y = yn-125,
			defaultFile = "assets/img/mbutton_stair.png",
			isEnabled = false,
			onRelease = getGoTo("long_stair", { effect = "fade", time = 300, params = { class = "ranger", level = "2" } } )
		}),

		--[[
		spire = widget.newButton({
			width = mbw,
			height = mbw,
			x = xn+130,
			y = yn-245,
			defaultFile = "assets/img/mbutton_spire.png",
			isEnabled = false,
			onRelease = getGoTo("long_stair", { effect = "fade", time = 300, params = { class = "fighter", level = "2" }  } )
		}),
		--]]

	}

	for key,value in pairs(mbutton) do
		midground:insert(value)
	end

	uibutton = {

		character = widget.newButton({
			label = "C",
			shape = "rect",
			fillColor = {
				default = { 0.2, 0.2, 0.2 },
				over = { 0.8, 0.8, 0.8 }
			},
			labelColor = {
				default = { 1, 1, 1 },
				over = { 0.2, 0.2, 0.2 }
			},
			width = ubw,
			height = ubw,
			x = (ubw/2)+ubp,
			y = height-(ubw/2)-ubp,
			isEnabled = true,
			onRelease = getGoTo( "overlay.character", { effect = "fromBottom", time = 300 } )
		}),

		achievements = widget.newButton({
			label = "A",
			shape = "rect",
			fillColor = {
				default = { 0.2, 0.2, 0.2 },
				over = { 0.8, 0.8, 0.8 }
			},
			labelColor = {
				default = { 1, 1, 1 },
				over = { 0.2, 0.2, 0.2 }
			},
			width = ubw,
			height = ubw,
			x = (ubw*1.5)+2*ubp,
			y = height-(ubw/2)-ubp,
			isEnabled = true
		}),

		classHall = widget.newButton({
			label = "H",
			shape = "rect",
			fillColor = {
				default = { 0.2, 0.2, 0.2 },
				over = { 0.8, 0.8, 0.8 }
			},
			labelColor = {
				default = { 1, 1, 1 },
				over = { 0.2, 0.2, 0.2 }
			},
			width = ubw,
			height = ubw,
			x = (ubw*2.5)+3*ubp,
			y = height-(ubw/2)-ubp,
			isEnabled = true
		}),

		accountSettings = widget.newButton({
			label = "S",
			shape = "rect",
			fillColor = {
				default = { 0.2, 0.2, 0.2 },
				over = { 0.8, 0.8, 0.8 }
			},
			labelColor = {
				default = { 1, 1, 1 },
				over = { 0.2, 0.2, 0.2 }
			},
			width = ubw,
			height = ubw,
			x = (ubw*3.5)+4*ubp,
			y = height-(ubw/2)-ubp,
			isEnabled = true
		}),
	}

	uiTray = display.newRect( interface, width/2, height-(ubw/2)-ubp, width, ubw+2*ubp )
	uiTray:setFillColor( 0.9 )

	uiTrayShadow = display.newRect( interface, width/2, height-(ubw+2*ubp)-32, width, 64 )
	uiTrayShadow.fill = {
		type = "image",
		filename = "assets/img/shadow.png"
	}

	for key,value in pairs(uibutton) do
		interface:insert(value)
	end

	--interface.x = xn-(width/2)

end



--[[
		Show Phase
--]]

function scene:show( event )
	phase = event.phase

	-- Will phase
	if phase == "will" then

	-- Did phase
	elseif phase == "did" then
		for key,value in pairs(mbutton) do
			value:setEnabled(true)
		end
	end
end



--[[
		Hide Phase
--]]

function scene:hide( event )
	phase = event.phase

end



--[[
		Destroy Phase
--]]

function scene:destroy( event )

end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene