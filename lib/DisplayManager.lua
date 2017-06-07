local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local widget = require "widget"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local DisplayManager = {}
local DisplayManagerMT = { __index = DisplayManager }

function DisplayManager.new( group )
	local self = {
		group = group
	}

	setmetatable( self, DisplayManagerMT )
	return self
end

function DisplayManager:build()
	-- Prompt Display creation
	self.promptBox = fx.newRect( xn, yo + theme.promptBoxPadding + theme.promptBoxHeight/2 + theme.promptBoxVerticalPadding, data.width - 2*theme.promptBoxPadding, theme.promptBoxHeight, theme.promptBoxColor )
	self.group:insert( self.promptBox )

	self.flavorText = fx.newShadowText( {
		text = "",
		x = xn,
		y = yo + theme.promptBoxPadding + theme.flavorVerticalDisplacement + theme.promptBoxVerticalPadding,
		font = theme.baseFontFamily,
		fontSize = theme.flavorFontSize,
		color = theme.white,
		align = "center",
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.dark
	} )
	self.group:insert( self.flavorText )

	local widthUnit = ( (xf-xo) - 2*theme.promptBoxPadding - 3*theme.promptTextPadding ) / 3
	self.promptLabel = fx.newShadowText( {
		text = "",
		x = xf - theme.promptBoxPadding - theme.promptTextPadding - widthUnit,
		y = yo + theme.promptBoxPadding + theme.promptTextVerticalDisplacement + theme.promptBoxVerticalPadding,
		width = 2*widthUnit,
		font = theme.boldFontFamily,
		fontSize = theme.promptFontSize,
		color = theme.white,
		align = "left",
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.dark
	} )
	self.group:insert( self.promptLabel )

	self.promptNumber = fx.newShadowText( {
		text = "",
		x = xo + widthUnit/2 + theme.promptBoxPadding + theme.promptTextPadding,
		y = yo + theme.promptBoxPadding + theme.promptTextVerticalDisplacement + theme.promptBoxVerticalPadding,
		width = widthUnit,
		font = theme.boldFontFamily,
		fontSize = theme.promptFontSize,
		color = theme.green,
		align = "right",
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.dark
	} )
	self.group:insert( self.promptNumber )

	-- Play Button creation
	self.playButton = ui.newCircleButton( {
		radius = theme.buttonRadius,
		color = {
			default = theme.green,
			over = theme.darkGreen
		},
		label = "Begin",
		fontSize = theme.buttonFontSize,
		fontFamily = theme.buttonFontFamily,
		labelColor = {
			default = theme.white,
			over = theme.darkWhite
		},
		labelShadow = true,
		icon = "playIcon",
		iconColor = {
			default = theme.white,
			over = theme.darkWhite
		},
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.medium
	} )
	self.group:insert( self.playButton )
	self.playButton.x = xn
	self.playButton.y = theme.promptBoxHeight + theme.promptBoxPadding + theme.promptBoxVerticalPadding

	-- Pause Button creation
	self.pauseButton = ui.newCircleButton( {
		radius = theme.buttonRadius,
		color = {
			default = theme.yellow,
			over = theme.darkYellow
		},
		label = "Pause",
		fontSize = theme.buttonFontSize,
		fontFamily = theme.buttonFontFamily,
		labelColor = {
			default = theme.white,
			over = theme.darkWhite
		},
		labelShadow = true,
		icon = "pauseIcon",
		iconColor = {
			default = theme.white,
			over = theme.darkWhite
		},
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.medium
	} )
	self.group:insert( self.pauseButton )
	self.pauseButton.x = xn
	self.pauseButton.y = yf - theme.buttonRadius - theme.buttonVerticalPadding
	self.pauseButton.isVisible = false

	return self.playButton, self.pauseButton
end

function DisplayManager:setFlavorText( string )
	self.flavorText:setText( string )
end

function DisplayManager:displayPrompt( label, number )
	self.promptLabel:setText( label )
	self.promptNumber:setText( tostring( number ) )
end

return DisplayManager