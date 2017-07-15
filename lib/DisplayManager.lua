local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local widget = require "widget"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local DisplayManager = {}
local DisplayManagerMT = { __index = DisplayManager }

function DisplayManager.new( group )
	local self = {
		group = group,
		isHidden = true
	}
	self.group.isVisible = false

	setmetatable( self, DisplayManagerMT )
	return self
end

function DisplayManager:build()
	-- Prompt Display creation
	self.questGiver = display.newImageRect( self.group, "assets/img/rangerface.png", 98, 113 )
	self.questGiver.x = xo + 47 + 10; self.questGiver.y = yo + 56 + 10

	self.promptBox = display.newImageRect( self.group, "assets/img/promptBubble.png", 270, 130 )
	self.promptBox.x = xf - 135 - 10; self.promptBox.y = yo + 65 + 10

	self.flavorText = fx.newShadowText( {
		text = "",
		width = 240,
		x = xf - 135 + 25,
		y = yo + 75 - 35,
		font = theme.baseFontFamily,
		fontSize = theme.flavorFontSize,
		color = theme.black,
		align = "left",
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.dark
	} )
	self.group:insert( self.flavorText )

	local widthUnit = ( xf - xo - theme.promptTextPadding*3 )/2
	self.promptLabel = fx.newShadowText( {
		text = "",
		x = xf - 135 - 10,
		y = yo + 72,
		width = widthUnit,
		font = theme.boldFontFamily,
		fontSize = theme.promptFontSize,
		color = theme.black,
		align = "center",
		shadowOffsetX = theme.shadow.x.medium,
		shadowOffsetY = theme.shadow.y.medium,
		shadowSize = theme.shadow.size.medium,
		shadowOpacity = theme.shadow.opacity.dark
	} )
	self.group:insert( self.promptLabel )

	self.promptNumber = fx.newShadowText( {
		text = "",
		x = xf - 135 - 10,
		y = yo + 72 + 36,
		width = widthUnit,
		font = theme.boldFontFamily,
		fontSize = theme.promptFontSize,
		color = theme.green,
		align = "center",
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

function DisplayManager:setFlavor( string )
	self.flavorText:setText( string )
end

function DisplayManager:setPrompt( label, number )
	self.promptLabel:setText( label )
	self.promptNumber:setText( tostring( number ) )
end

function DisplayManager:setConfiguration( configuration )
	if self.isHidden then
		self.isHidden = false
		self.group.isVisible = true
	end
	if configuration == "active" then
		self.promptBox.isVisible = false
		self.questGiver.isVisible = false
		self.flavorText.isVisible = false
		
		--self.pauseButton.isVisible = true
		self.pauseButton.x = theme.buttonMiddleLeft.x
		self.pauseButton.y = theme.buttonMiddleLeft.y

		self.playButton.x = theme.buttonBottomCenter.x
		self.playButton.y = theme.buttonBottomCenter.y
		self.playButton:setLabelText( "Done" )

		self.promptLabel.x = xo + self.promptLabel.width/2 + theme.promptTextPadding
		self.promptLabel.y = yo + theme.promptTextPadding + theme.promptFontSize
		self.promptLabel:setColor( theme.white )

		self.promptNumber.x = xf - self.promptNumber.width/2 - theme.promptTextPadding
		self.promptNumber.y = yo + theme.promptTextPadding + theme.promptFontSize
	end
	if configuration == "init" then
		self.promptBox.isVisible = true
		self.questGiver.isVisible = true
		self.flavorText.isVisible = true

		self.pauseButton.isVisible = false

		self.playButton.isVisible = true
		self.playButton:setLabelText( "Begin" )
		self.playButton.x = theme.buttonMiddleRight.x
		self.playButton.y = theme.buttonMiddleRight.y

		self.promptLabel.y = yo + 72
		self.promptLabel.x = xf - 135 - 10
		self.promptLabel:setColor( theme.black )

		self.promptNumber.y = yo + 72 + 36
		self.promptNumber.x = xf - 135 - 10
	end
end

function DisplayManager:hide()
	self.isHidden = true
	self.group.isVisible = false
end

return DisplayManager