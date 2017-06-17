local data = require "lib.data"
local theme = require "lib.theme"
local fn = require "lib.fn"
local fx = require "lib.fx"

local widget = require "widget"

local ui = {}

function ui.newButton( options )
	local g = display.newGroup()
	local radius = options.radius or 0
	g.callback = options.callback or nil

	local b = fx.newRoundedRect( 0, 0, options.width, options.height, options.radius, options.color.default )
	local s = fx.newDropShadow( "roundedRect", {
		width = options.width,
		height = options.height,
		cornerRadius = radius,
		offsetX = options.shadowOffsetX,
		offsetY = options.shadowOffsetY,
		size = options.shadowSize,
		opacity = options.shadowOpacity
	} )

	g:insert(s); g:insert(b)

	local t = nil
	if options.label ~= nil then
		t = display.newText( {
			text = options.label,
			width = options.width,
			font = options.fontFamily,
			fontSize = options.fontSize,
			align = "center"
		} )
		t:setFillColor( fn.cparse( options.labelColor.default ) )
		g:insert(t)
	end


	b:addEventListener( "touch", function( event ) 
		if event.phase == "began" then
			fx.setColor( b, options.color.over ); b:translate( 2, 2 )
			if t ~= nil then t:setFillColor( fn.cparse( options.labelColor.over ) ); t:translate( 2, 2 ) end
			display.getCurrentStage():setFocus( b )
		elseif event.phase == "ended" or event.phase == "cancelled" then
			fx.setColor( b, options.color.default ); b:translate( -2, -2 )
			if t ~= nil then t:setFillColor( fn.cparse( options.labelColor.default ) ); t:translate( -2, -2 ) end
			display.getCurrentStage():setFocus( nil )
		end

		if event.phase == "ended" then
			local inXBounds = event.x >= g.x - options.width/2 and event.x <= g.x + options.width/2
			local inYBounds = event.y >= g.y - options.height/2 and event.y <= g.y + options.height/2
			if inXBounds and inYBounds and g.callback ~= nil then
				g.callback( event )
			end
		end
	end )

	return g
end

function ui.newCircleButton( options )
	local g = display.newGroup()
	g.callback = options.callback or nil

	local b = fx.newCircle( 0, 0, options.radius, options.color.default )
	local s = fx.newDropShadow( "circle", {
		width = 2*options.radius,
		height = 2*options.radius,
		offsetX = options.shadowOffsetX,
		offsetY = options.shadowOffsetY,
		size = options.shadowSize,
		opacity = options.shadowOpacity
	} )	

	g:insert(s); g:insert(b)

	local t = nil
	if options.label ~= nil then
		t = display.newText( {
			text = options.label,
			font = options.fontFamily,
			fontSize = options.fontSize,
			align = "center",
		} )
		t:setFillColor( fn.cparse( options.labelColor.default ) )

		if options.labelShadow == true then
			local d = display.newGroup();
			d:insert( fx.newTextShadow( {
				offsetX = options.shadowOffsetX,
				offsetY = options.shadowOffsetY,
				size = options.shadowSize,
				opacity = options.shadowOpacity,
				textOptions = {
					text = options.label,
					font = options.fontFamily,
					fontSize = options.fontSize,
					align = "center"
				}
			} ) )
			d:insert(t); g:insert(d)
			d.y = options.radius + options.fontSize/2
		else
			g:insert(t)
			t.y = options.radius + options.fontSize/2
		end
	end

	local i = nil
	if options.icon ~= nil then
		i = display.newImageRect( g, "assets/img/ui/" .. options.icon .. ".png", 2*options.radius, 2*options.radius )
		i:setFillColor( fn.cparse( options.iconColor.default ) )
	end


	b:addEventListener( "touch", function( event ) 
		if event.phase == "began" then
			fx.setColor( b, options.color.over ); b:translate( 2, 2 )
			--if t ~= nil then t:setFillColor( options.labelColor.over ); t:translate( 2, 2 ) end
			if i ~= nil then i:setFillColor( fn.cparse( options.iconColor.over ) ); i:translate( 2, 2 ) end
			display.getCurrentStage():setFocus( b )
		elseif event.phase == "ended" or event.phase == "cancelled" then
			fx.setColor( b, options.color.default ); b:translate( -2, -2 )
			--if t ~= nil then t:setFillColor( options.labelColor.default ); t:translate( -2, -2 ) end
			if i ~= nil then i:setFillColor( fn.cparse( options.iconColor.default ) ); i:translate( -2, -2 ) end
			display.getCurrentStage():setFocus( nil )
		end

		if event.phase == "ended" and math.sqrt( (event.x-g.x)*(event.x-g.x) + (event.y-g.y)*(event.y-g.y) ) <= options.radius then
			if g.callback ~= nil then g.callback( event ) end
		end
	end )

	return g
end

function ui.newImageButton( options )
	local g = display.newGroup()
	g.callback = options.callback or nil

	local hitWidth, hitHeight = options.hitWidth or nil, options.hitHeight or nil
	local imageWidth, imageHeight = options.imageWidth or nil, options.imageHeight or nil
	if options.width ~= nil then hitWidth, imageWidth = options.width, options.width end
	if options.height ~= nil then hitHeight, imageHeight = options.height, options.height end

	local h = display.newRect( 0, 0, hitWidth, hitHeight )
	h.isVisible = false; h.isHitTestable = true
	local i = display.newImageRect( g, options.image, imageWidth, imageHeight )
	i.isHitTestable = false; g:insert( h )

	-- Insert shadow creation here

	local t = nil
	if options.label ~= nil then
		t = display.newText( {
			text = options.label,
			font = options.fontFamily,
			fontSize = options.fontSize,
			align = "center",
		} )
		t:setFillColor( fn.cparse( options.labelColor.default ) )

		if options.labelShadow == true then
			local d = display.newGroup();
			d:insert( fx.newTextShadow( {
				offsetX = options.shadowOffsetX,
				offsetY = options.shadowOffsetY,
				size = options.shadowSize,
				opacity = options.shadowOpacity,
				textOptions = {
					text = options.label,
					font = options.fontFamily,
					fontSize = options.fontSize,
					align = "center"
				}
			} ) )
			d:insert(t); g:insert(d)
			d.y = ( options.height + options.fontSize )/2
		else
			g:insert(t)
			t.y = ( options.height + options.fontSize )/2
		end
	end

	h:addEventListener( "touch", function( event ) 
		if event.phase == "began" then
			-- Over look
		elseif event.phase == "ended" or event.phase == "cancelled" then
			-- Reset look
		end

		if event.phase == "ended" then
			local inXBounds = event.x >= g.x - options.width/2 and event.x <= g.x + options.width/2
			local inYBounds = event.y >= g.y - options.height/2 and event.y <= g.y + options.height/2
			if inXBounds and inYBounds and g.callback ~= nil then
				g.callback( event )
			end
		end
	end )

	return g
end

function ui.newTimer( parentGroup, x, y, width, height, mode, theme, duration )

	local timer = {}
	local group = display.newGroup()

	-- Countdown Timer creation
	if mode == "countdown" then
		timer.duration = duration*1000
		timer.time = duration*1000
		timer.lastTime = 0

		local themeSheet = graphics.newImageSheet( "assets/img/ui/progressBar.png", {
			width = 50,
			height = 50,
			numFrames = 12,
			sheetContentWidth = 300,
			sheetContentHeight = 100
		} )
		local frame
		if theme == "blue" then
			frame = { 4, 5, 6 }
		elseif theme == "red" then
			frame = { 7, 8, 9 }
		elseif theme == "gold" then
			frame = { 10, 11, 12 }
		end

		timer.timerBar = widget.newProgressView( {
			x = x,
			y = y,
			width = width,
			isAnimated = false,
			sheet = themeSheet,
			fillOuterLeftFrame = 1,
			fillOuterMiddleFrame = 2,
			fillOuterRightFrame = 3,
			fillOuterWidth = 50,
			fillOuterHeight = 50,
			fillInnerLeftFrame = frame[1],
			fillInnerMiddleFrame = frame[2],
			fillInnerRightFrame = frame[3],
			fillWidth = 50,
			fillHeight = 50,
		} )
		group:insert( timer.timerBar )
		timer.timerBar:setProgress( 1 )

		function timer.start( event )
			Runtime:addEventListener( "enterFrame", timer.update )
		end

		function timer.finish( event )
			Runtime:removeEventListener( "enterFrame", timer.update )
		end

		function timer.update( event )
			if timer.lastTime == 0 then
				timer.lastTime = event.time
			end
			local delta = event.time - timer.lastTime
			timer.lastTime = event.time
			timer.time = timer.time - delta
			if timer.time <= 0.0 then
				timer.timerBar:setProgress( 0.0 )
				timer:finish( event )
			else
				timer.timerBar:setProgress( timer.time/timer.duration )
			end
		end

	end
	-- End countdown mode

	timer.group = group
	parentGroup:insert( group )
	return timer

end

return ui