--[[
		Initial Declarations
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer, json, widget = require "composer", require "json", require "widget"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

-- Scene Variables
local scene = composer.newScene()
local background, midground, foreground, interface
local map, mbutton, uibutton, uiTray, uiTrayShadow

local view, phase, params

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local mbw, ubw = 60, width/4.5 -- Map button width, UI button width
local buttonWidth = width/5.25; local buttonPadding = buttonWidth/4

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

		spire = widget.newButton({
			width = mbw,
			height = mbw,
			x = xn+130,
			y = yn-245,
			defaultFile = "assets/img/mbutton_spire.png",
			isEnabled = false,
			onRelease = getGoTo("classHall_ranger", { effect = "fade", time = 300, params = { class = "fighter", level = "2" }  } )
		}),

	}

	for key,value in pairs(mbutton) do
		midground:insert(value)
	end

	local character = ui.newImageButton({
		hitWidth = buttonWidth,
		hitHeight = buttonWidth,
		imageHeight = buttonWidth + 2*buttonPadding,
		imageWidth = buttonWidth + 2*buttonPadding,
		image = "icon_character"
	})
	interface:insert( character )
	character.x = xo + buttonPadding + buttonWidth/2
	character.y = yf - buttonPadding - buttonWidth/2

	local achievements = ui.newImageButton({
		hitWidth = buttonWidth,
		hitHeight = buttonWidth,
		imageHeight = buttonWidth + 2*buttonPadding,
		imageWidth = buttonWidth + 2*buttonPadding,
		image = "icon_achievements"
	})
	interface:insert( achievements )
	achievements.x = xo + buttonPadding*2 + 3*buttonWidth/2
	achievements.y = yf - buttonPadding - buttonWidth/2

	local classHall = fx.newRect( unpack{
		xo + buttonPadding*3 + 5*buttonWidth/2,
		yf - buttonPadding - buttonWidth/2,
		buttonWidth,
		buttonWidth,
		{ 0.2, 0.2, 0.2 }
	} )
	interface:insert( classHall )

	local messages = ui.newImageButton({
		hitWidth = buttonWidth,
		hitHeight = buttonWidth,
		imageHeight = buttonWidth + 2*buttonPadding,
		imageWidth = buttonWidth + 2*buttonPadding,
		image = "icon_messages"
	});
	interface:insert( messages )
	messages.x = xo + buttonPadding*4 + 7*buttonWidth/2
	messages.y = yf - buttonPadding - buttonWidth/2

	--[[
	
	local classHall = widget.newButton({
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

	local accountSettings = widget.newButton({
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
	--]]

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