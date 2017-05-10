local sceneName = "Encounter Start"
local composer = require "composer"
local widget = require "widget"
local json = require "json"
local util = require "lib.util"
local raleway, unifraktur = "assets/font/Raleway 500.ttf", "assets/font/UnifrakturCook 700.ttf"
local raleway_bold = "assets/font/Raleway 700.ttf"

local view, params

-- Scene Variables
local scene = composer.newScene()
local background, midground, foreground, interface
local backgroundImage, stat, character

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local boxWidth, boxPadding, labelLength, labelPadding, labelTextSize, labelTextPadding = 40, 5, 140, 10, 18, 8

--[[
		Creation Phase
--]]

function scene:create( event )

	-- Character File Import
	--local path = system.pathForFile( "chars.json", system.ResourceDirectory )
	local path = "D:/Calliope/Demo/data/chars.json"
	local file, errorString = io.open( path, "r" )

	if not file then
		print( "File error: " .. errorString )
	else
		local content = file:read( "*a" )
		character = json.decode( content )
	end
	io.close()

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
	backgroundImage = display.newRect( background, xn, yn, width, height )
	backgroundImage:setFillColor( 0.2 )

	stat = {
		strength = {
			name = "Strength",
			index = 1
		},
		speed = {
			name = "Speed",
			index = 2
		},
		agility = {
			name = "Agility",
			index = 3
		},
		endurance = {
			name = "Endurance",
			index = 4
		}
	};
	local index, labelX, boxX, boxY
	for key, value in pairs( stat ) do
		index = value.index
		labelX, boxX, boxY = (labelLength+boxWidth+2*boxPadding)/2+labelPadding, labelPadding+boxPadding+boxWidth/2, 40+labelPadding*index+(boxWidth+boxPadding)*(index - 0.5)

		value.labelBox = display.newRect( background, labelX, boxY, labelLength+boxWidth+2*boxPadding, boxWidth+2*boxPadding )
		value.labelBox:setFillColor( 0.1 )

		value.statBox = display.newRect( background, boxX, boxY, boxWidth, boxWidth )
		value.statBox:setFillColor( 0 )

		value.label = display.newText({
			parent = midground,
			text = value.name,
			x = labelX+labelTextPadding+boxWidth/2,
			y = boxY,
			font = unifraktur,
			fontSize = labelTextSize,
			align = left,
			width = labelLength
		})

		value.score = display.newText({
			parent = midground,
			text = character.stat[""..index],
			x = boxX,
			y = boxY,
			font = raleway,
			fontSize = labelTextSize,
		})
	end



end



--[[
		Show Phase
--]]

function scene:show( event )

	-- Initialize variables
	local view = self.view
	local phase = event.phase

	-- Will phase
	if phase == "will" then

	-- Did phase
	elseif phase == "did" then

	end
end



--[[
		Hide Phase
--]]

function scene:hide( event )

	local view = self.view

end



--[[
		Destroy Phase
--]]

function scene:destroy( event )

	local view = self.view

end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene