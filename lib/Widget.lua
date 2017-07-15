local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local widget = require "widget"

local Widget = {}
local WidgetMT = { __index = Widget }

function Widget:remove()
	-- Note: this is ugly AF. Wishlist includes figuring out why widget:removeSelf() isn't working.
	self.widget.isVisible = false
	self.widget = nil
end

--[[
		Countdown Widget
--]]
function Widget.countdown( options )
	local self = {
		duration = options.duration,
		currentTime = options.duration,
		widget = widget.newProgressView( {
			x = theme.countdownWidgetX,
			y = theme.countdownWidgetY,
			width = theme.countdownWidgetWidth,
			height = theme.countdownWidgetHeight,
			isAnimated = false,

			sheet = theme.countdownImageSheet,
			fillWidth = theme.countdownWidgetFillWidth,
			fillHeight = theme.countdownWidgetFillHeight,
			fillOuterWidth = theme.countdownWidgetFillOuterWidth,
			fillOuterHeight = theme.countdownWidgetFillOuterHeight,
			fillOuterLeftFrame = 1,
			fillOuterMiddleFrame = 2,
			fillOuterRightFrame = 3,
			fillInnerLeftFrame = 4,
			fillInnerMiddleFrame = 5,
			fillInnerRightFrame = 6
		} )
	}

	if options.callback ~= nil then self.callback = options.callback end

	function self:update( delta )
		self.currentTime = self.currentTime - delta
		if self.currentTime <= delta then
			self.widget:setProgress( 0.0 )
			if self.callback ~= nil then self.callback() end
		else
			self.widget:setProgress( self.currentTime/self.duration )
		end
	end

	if options.group ~= nil then options.group:insert( self.widget ) end
	
	setmetatable( self, WidgetMT )
	return self
end

return Widget