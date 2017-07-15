local xn, yn = display.contentCenterX, display.contentCenterY
local width, height = display.actualContentWidth, display.actualContentHeight
local xo, yo, xf, yf = xn-width/2, yn-height/2, xn+width/2, yn+height/2

local Region = {}
local RegionMT = { __index = Region }

local debug = false
--local debug = true

function Region.new()
	local newInstance = {}
	setmetatable( newInstance, RegionMT )
	return newInstance
end

function Region.createFromData( data, regions, points )
	local newRegion = nil
	if data.constructor == "union" then
		newRegion = Region.new()
		for key, value in pairs( data.args ) do
			if type( value ) == "string" then
				newRegion = newRegion .. regions[ value ]
			elseif type( value ) == "table" then
				newRegion = newRegion .. Region.createFromData( value, regions, points )
			end
		end
	elseif data.constructor == "intersection" then
		newRegion = Region.new()
		for key, value in pairs( data.args ) do
			if type( value ) == "string" then
				newRegion = newRegion + regions[ value ]
			elseif type( value ) == "table" then
				newRegion = newRegion + Region.createFromData( value, regions, points )
			end
		end
	else
		newRegion = Region[data.constructor]( Region.pointilize( data.args, points ) )
	end
	return newRegion
end

function Region.pointilize( args, points )
	local results = {}
	for i, point in ipairs( args ) do
		results[i] = points[ point ]
	end
	return unpack( results )
end

function Region.contains( point )
	if debug then
		local circ = display.newCircle( point.x, point.y, 12 )
		circ:setFillColor( 0.9, 0.2, 0.2, 0.7 )
	end
	return true
end

function Region:point()
	local point
	repeat
		point = { x = math.random( xo, xf ), y = math.random( yo, yf ) }
	until self.contains( point )
	if debug then
		local circ = display.newCircle( point.x, point.y, 12 )
		circ:setFillColor( 0.9, 0.2, 0.2, 0.7 )
	end
	print( self.contains( point ) )
	return point
end

function RegionMT.__add( r1, r2 )
	local newRegion = Region.new()
	function newRegion.contains( point )
		return r1.contains( point ) and r2.contains( point )
	end
	return newRegion
end

function RegionMT.__concat( r1, r2 )
	local newRegion = Region.new()
	function newRegion.contains( point )
		return r1.contains( point ) or r2.contains( point )
	end
	return newRegion
end

function Region.below(...)
	local newInstance = Region.new()
	if arg.n == 1 then
		newInstance.contains = function( point ) return point.y > arg[1].y end
		if debug then
			local circ = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ:setFillColor( 0.2, 0.2, 0.9, 0.7 )
			local line = display.newLine( arg[1].x-120, arg[1].y, arg[1].x+120, arg[1].y )
			line:setStrokeColor( 0.2, 0.2, 0.9, 0.7 ); line.strokeWidth = 2
			local norm = display.newLine( arg[1].x, arg[1].y, arg[1].x, arg[1].y+50)
			norm:setStrokeColor( 0.2, 0.2, 0.9, 0.7 ); norm.strokeWidth = 2
		end
	else
		local slope = (arg[2].y-arg[1].y)/(arg[2].x-arg[1].x)
		newInstance.contains = function( point )
			return point.y > slope*(point.x-arg[1].x)+arg[1].y
		end
		if debug then
			local circ1 = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ1:setFillColor( 0.2, 0.2, 0.9, 0.7 )
			local circ2 = display.newCircle( arg[2].x, arg[2].y, 12 )
			circ2:setFillColor( 0.2, 0.2, 0.9, 0.7 )
			local line = display.newLine( arg[1].x, arg[1].y, arg[2].x, arg[2].y )
			line:setStrokeColor( 0.2, 0.2, 0.9, 0.7 ); line.strokeWidth = 2
			local norm1 = display.newLine( arg[1].x, arg[1].y, arg[1].x, arg[1].y+50)
			norm1:setStrokeColor( 0.2, 0.2, 0.9, 0.7 ); norm1.strokeWidth = 2
			local norm2 = display.newLine( arg[2].x, arg[2].y, arg[2].x, arg[2].y+50)
			norm2:setStrokeColor( 0.2, 0.2, 0.9, 0.7 ); norm2.strokeWidth = 2
		end
	end
	return newInstance
end

function Region.above(...)
	local newInstance = Region.new()
	if arg.n == 1 then
		newInstance.contains = function( point ) return point.y < arg[1].y end
		if debug then
			local circ = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ:setFillColor( 0.2, 0.9, 0.2, 0.7 )
			local line = display.newLine( arg[1].x-120, arg[1].y, arg[1].x+120, arg[1].y )
			line:setStrokeColor( 0.2, 0.9, 0.2, 0.7 ); line.strokeWidth = 2
			local norm = display.newLine( arg[1].x, arg[1].y, arg[1].x, arg[1].y-50)
			norm:setStrokeColor( 0.2, 0.9, 0.2, 0.7 ); norm.strokeWidth = 2
		end
	else
		local slope = (arg[2].y-arg[1].y)/(arg[2].x-arg[1].x)
		newInstance.contains = function( point )
			return point.y < slope*(point.x-arg[1].x)+arg[1].y
		end
		if debug then
			local circ1 = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ1:setFillColor( 0.2, 0.9, 0.2, 0.7 )
			local circ2 = display.newCircle( arg[2].x, arg[2].y, 12 )
			circ2:setFillColor( 0.2, 0.9, 0.2, 0.7 )
			local line = display.newLine( arg[1].x, arg[1].y, arg[2].x, arg[2].y )
			line:setStrokeColor( 0.2, 0.9, 0.2, 0.7 ); line.strokeWidth = 2
			local norm1 = display.newLine( arg[1].x, arg[1].y, arg[1].x, arg[1].y-50)
			norm1:setStrokeColor( 0.2, 0.9, 0.2, 0.7 ); norm1.strokeWidth = 2
			local norm2 = display.newLine( arg[2].x, arg[2].y, arg[2].x, arg[2].y-50)
			norm2:setStrokeColor( 0.2, 0.9, 0.2, 0.7 ); norm2.strokeWidth = 2
		end
	end
	return newInstance
end

function Region.leftOf(...)
	local newInstance = Region.new()
	if arg.n == 1 then
		newInstance.contains = function( point ) return point.x < arg[1].x end
		if debug then
			local circ = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ:setFillColor( 0.9, 0.2, 0.9, 0.7 )
			local line = display.newLine( arg[1].x, arg[1].y-120, arg[1].x, arg[1].y+120 )
			line:setStrokeColor( 0.9, 0.2, 0.9, 0.7 ); line.strokeWidth = 2
			local norm = display.newLine( arg[1].x, arg[1].y, arg[1].x-50, arg[1].y)
			norm:setStrokeColor( 0.9, 0.2, 0.9, 0.7 ); norm.strokeWidth = 2
		end
	else
		local slope = (arg[2].x-arg[1].x)/(arg[2].y-arg[1].y)
		newInstance.contains = function( point )
			return point.x < slope*(point.y-arg[1].y)+arg[1].x
		end
		if debug then
			local circ1 = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ1:setFillColor( 0.9, 0.2, 0.9, 0.7 )
			local circ2 = display.newCircle( arg[2].x, arg[2].y, 12 )
			circ2:setFillColor( 0.9, 0.2, 0.9, 0.7 )
			local line = display.newLine( arg[1].x, arg[1].y, arg[2].x, arg[2].y )
			line:setStrokeColor( 0.9, 0.2, 0.9, 0.7 ); line.strokeWidth = 2
			local norm1 = display.newLine( arg[1].x, arg[1].y, arg[1].x-50, arg[1].y)
			norm1:setStrokeColor( 0.9, 0.2, 0.9, 0.7 ); norm1.strokeWidth = 2
			local norm2 = display.newLine( arg[2].x, arg[2].y, arg[2].x-50, arg[2].y)
			norm2:setStrokeColor( 0.9, 0.2, 0.9, 0.7 ); norm2.strokeWidth = 2
		end
	end
	return newInstance
end

function Region.rightOf(...)
	local newInstance = Region.new()
	if arg.n == 1 then
		newInstance.contains = function( point ) return point.x > arg[1].x end
		if debug then
			local circ = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ:setFillColor( 0.9, 0.9, 0.2, 0.7 )
			local line = display.newLine( arg[1].x, arg[1].y-120, arg[1].x, arg[1].y+120 )
			line:setStrokeColor( 0.9, 0.9, 0.2, 0.7 ); line.strokeWidth = 2
			local norm = display.newLine( arg[1].x, arg[1].y, arg[1].x+50, arg[1].y)
			norm:setStrokeColor( 0.9, 0.9, 0.2, 0.7 ); norm.strokeWidth = 2
		end
	else
		local slope = (arg[2].x-arg[1].x)/(arg[2].y-arg[1].y)
		newInstance.contains = function( point )
			return point.x > slope*(point.y-arg[1].y)+arg[1].x
		end
		if debug then
			local circ1 = display.newCircle( arg[1].x, arg[1].y, 12 )
			circ1:setFillColor( 0.9, 0.9, 0.2, 0.7 )
			local circ2 = display.newCircle( arg[2].x, arg[2].y, 12 )
			circ2:setFillColor( 0.9, 0.9, 0.2, 0.7 )
			local line = display.newLine( arg[1].x, arg[1].y, arg[2].x, arg[2].y )
			line:setStrokeColor( 0.9, 0.9, 0.2, 0.7 ); line.strokeWidth = 2
			local norm1 = display.newLine( arg[1].x, arg[1].y, arg[1].x+50, arg[1].y)
			norm1:setStrokeColor( 0.9, 0.9, 0.2, 0.7 ); norm1.strokeWidth = 2
			local norm2 = display.newLine( arg[2].x, arg[2].y, arg[2].x+50, arg[2].y)
			norm2:setStrokeColor( 0.9, 0.9, 0.2, 0.7 ); norm2.strokeWidth = 2
		end
	end
	return newInstance
end

return Region