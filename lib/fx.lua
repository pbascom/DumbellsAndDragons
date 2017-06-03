local data = require "lib.data"
local theme = require "lib.theme"
local fn = require "lib.fn"

local fx = {}

--
-- Adds a stroke to a shape (fixing antialiasing)
--
function fx.stroke( shape, color, thickness )
	if thickness == nil then thickness = 2 end
	shape.stroke = { type="image", filename="assets/img/fx/stroke" .. thickness .. ".png" }
	shape.strokeWidth = thickness+2
	shape:setStrokeColor( fn.cparse( color ) )
	return shape
end

--
-- These shapes look nice!
--
function fx.newCircle( xPos, yPos, radius, color )
	local c = display.newCircle( xPos, yPos, radius - 2 )
	c:setFillColor( fn.cparse( color ) )
	fx.stroke( c, color, 2 )
	return c
end

function fx.newRect( xPos, yPos, width, height, color )
	local r = display.newRect( xPos, yPos, width - 4, height - 4 )
	r:setFillColor( fn.cparse( color ) )
	fx.stroke( r, color, 2 )
	return r
end

function fx.newRoundedRect( xPos, yPos, width, height, radius, color )
	local r = display.newRoundedRect( xPos, yPos, width - 4, height - 4, radius )
	r:setFillColor( fn.cparse( color ) )
	fx.stroke( r, color, 2 )
	return r
end

function fx.setColor( shape, color )
	shape:setFillColor( fn.cparse( color ) )
	shape:setStrokeColor( fn.cparse( color ) )
end

--
-- Builds a new text shadow based on a supplied textOptions table.
--
-- Options: offsetX, offsetY, size, opacity, textOptions
--
function fx.newTextShadow( options )
	local g = display.newGroup()
	local textOptions = options.textOptions
	local parentGroup = textOptions.parent or nil
	textOptions.parent = nil

	local textObject = display.newText( textOptions )

	local height = textOptions.height or textObject.contentHeight
	local width = textOptions.width or textObject.contentWidth
	local offsetX, offsetY = ( options.offsetX or 0 ), ( options.offsetY or 0 )
	local size = options.size
	local opacity = options.opacity

	g.x, g.y = offsetX, offsetY
	textObject:setFillColor( 0 )

	local cW = width + size
	local cH = height + size
	local snapshot = display.newSnapshot( cW, cH )
	snapshot.group:insert( textObject )
	snapshot.fill.effect = "filter.blurGaussian"
	snapshot.fill.effect.horizontal.blurSize = size
	snapshot.fill.effect.horizontal.sigma = size
	snapshot.fill.effect.vertical.blurSize = size
	snapshot.fill.effect.vertical.sigma = size
	snapshot.alpha = options.opacity or 0.2
	snapshot:invalidate()
	g:insert( snapshot )

	return g
end

--
-- Creates a new text object with a shadow. Returns a display group.
--
--[[
		Options:
		parent,
		text,
		x,
		y,
		width,
		height,
		font,
		fontSize,
		align,
		shadowOffsetX,
		shadowOffsetY,
		shadowSize,
		shadowOpacity
--]]
function fx.newShadowText( options )
	local g = display.newGroup()
	local textOptions = {
		parent = g,
		text = options.text,
		x = options.x,
		y = options.y,
		width = options.width or nil,
		height = options.width or nil,
		font = options.font,
		fontSize = options.fontSize,
		align = options.align or nil
	}

	local textObject = display.newText( textOptions )
	textObject:setFillColor( fn.cparse ( options.color ) )

	local shadowObject = fx.newTextShadow( {
		offsetX = options.shadowOffsetX,
		offsetY = options.shadowOffsetY,
		size = options.shadowSize,
		opacity = options.shadowOpacity,
		textOptions = textOptions
	} )
	shadowObject:toBack()

	if options.parent ~= nil then options.parent:insert(g) end
	return g
end

--
-- Builds a drop shadow based on a shape (circle, rect, roundedRect)
--
-- Options: width, height, offsetX, offsetY, size, cornerRadius, opacity
--
function fx.newDropShadow( shape, options, group )
	local g = group or display.newGroup()
	local width, height = options.width, options.height
	local offsetX, offsetY = (options.offsetX or 0), (options.offsetY or 0)
	local size = options.size
	local cornerRadius = options.cornerRadius or 5
	local opacity = options.opacity
	local d = nil

	g.x, g.y = offsetX, offsetY

	if shape == "rect" then
		d = display.newRect( offsetX, offsetY, width, height )
		d:setFillColor( 0 )
	elseif shape == "roundedRect" then
		d = display.newRoundedRect( offsetX, offsetY, width, height, cornerRadius )
		d:setFillColor( 0 )
	elseif shape == "circle" then
		local radius = width * 0.5
		d = display.newCircle( offsetX, offsetY, radius )
		d:setFillColor( 0 )
	end

	if d == nil then return g end

	local cW = width + size
	local cH = height + size
	local snapshot = display.newSnapshot( cW, cH )
	snapshot.group:insert( d )
	snapshot.fill.effect = "filter.blurGaussian"
	snapshot.fill.effect.horizontal.blurSize = size
	snapshot.fill.effect.horizontal.sigma = size
	snapshot.fill.effect.vertical.blurSize = size
	snapshot.fill.effect.vertical.sigma = size
	snapshot.alpha = options.opacity or 0.2
	snapshot:invalidate()
	g:insert( snapshot )

	-- mui logs the shadow and its properties with shadowShapeDict at this point. Not sure if we'll need to do that, but keep it in mind.

	return g
end

return fx