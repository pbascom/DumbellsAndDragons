--[[
		Initial Declarations
--]]


-- Requirements
local composer = require "composer"
local widget = require "widget"
local json = require "json"
local spine = require "lib.spine"
local util = require "lib.util"

-- Encounter Variables
local name, id = "The Long Stair", "stair"
local source, assets, script
local lastTime = 0

-- Scene Variables
local view, phase, params, source
local scene = composer.newScene()
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
local background, midground, foreground, interface
local backgroundImage, hero, heroics

local button;
local bw = 80 --Button Width
local bp = (width-4*bw)/5 -- Button Padding


--[[
		Creation Event
--]]

function scene:create( event )

	-- Load Assets
	params = event.params
	local path = system.pathForFile( "" .. id .. ".json", system.DocumentsDirectory )
	--local path = "/data/"..id..".json"
	local file, errorString = io.open( path, "r" )
	if not file then
		print("File Error: " .. errorString)
	else
		source = json.decode( file:read( "*a" ) )
	end
	io.close()

	assets = source[params.class].assets; script = source[ params.class ][ params.level ]
	print( params.class, assets.motions[1], script[1].prompt.motion )

	-- Prepare display groups
	view = self.view

	background = display.newGroup()
	view:insert( background )

	midground = display.newGroup()
	view:insert( midground )

	foreground = display.newGroup()
	view:insert( foreground )

	interface = display.newGroup()
	view:insert( interface )

	-- Prep Content: first we start with static images
	backgroundImage = display.newImageRect( "assets/img/longStair_bg.png", 480, 640 )
	background:insert( backgroundImage ); backgroundImage.x = xn; backgroundImage.y = yn

	-- Next, sprites and changeables. Note: first we make it work, then we generalize.
	local data = util.loadSkeleton( "legodude", 0.25 )
	hero, heroics = data.skeleton, data.state
	foreground:insert( hero.group )

	Runtime:addEventListener( "enterFrame", function (event)
		local currentTime = event.time/1500
		local delta = currentTime - lastTime
		lastTime = currentTime

		hero.group.isVisible = true

		heroics:update(delta)
		heroics:apply(hero)
		hero:updateWorldTransform()
	end )

	button = {

		none = widget.newButton({
			label = "N",
			shape = "rect",
			fillColor = {
				default = { 0.2, 0.2, 0.2 },
				over = { 0.8, 0.8, 0.8 }
			},
			labelColor = {
				default = { 1, 1, 1 },
				over = { 0.2, 0.2, 0.2 }
			},
			width = bw,
			height = bw,
			x = (bw/2)+bp,
			y = height-(bw/2)-bp,
			isEnabled = true,
			onRelease = function()
				heroics:setEmptyAnimation( 0, 0.2 )
			end
		}),

		run = widget.newButton({
			label = "R",
			shape = "rect",
			fillColor = {
				default = { 0.2, 0.2, 0.2 },
				over = { 0.8, 0.8, 0.8 }
			},
			labelColor = {
				default = { 1, 1, 1 },
				over = { 0.2, 0.2, 0.2 }
			},
			width = bw,
			height = bw,
			x = (bw*1.5)+2*bp,
			y = height-(bw/2)-bp,
			isEnabled = true,
			onRelease = function()
				heroics:setAnimationByName( 0, "run", true )
			end
		}),

		squat = widget.newButton({
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
			width = bw,
			height = bw,
			x = (bw*2.5)+3*bp,
			y = height-(bw/2)-bp,
			isEnabled = true,
			onRelease = function()
				heroics:setAnimationByName( 0, "airSquat", true )
			end
		}),

		climb = widget.newButton({
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
			width = bw,
			height = bw,
			x = (bw*3.5)+4*bp,
			y = height-(bw/2)-bp,
			isEnabled = true,
			onRelease = function()
				heroics:setAnimationByName( 0, "runUpStairs", true )
			end
		})
	}

	for key,value in pairs( button ) do
		interface:insert( value )
	end

end



--[[
		Show Event
--]]

function scene:show( event )
	phase= event.phase

	--[[
			Will phase
	--]]
	if phase == "will" then
		-- Place and prepare skeletons
		hero.group.x, hero.group.y = xn, yn+140
		heroics:setEmptyAnimation( 0, 0 )

		-- Load encounter start screen with params
		composer.showOverlay( "scene.encounter_start" )

		

	--[[
			Did phase
	--]]
	elseif phase == "did" then
		--heroics:setAnimationByName( 0, "run", true )

	end
end



--[[
		Hide Event
--]]

function scene:hide( event )


end



--[[
		Destroy Phase
--]]

function scene:destroy( event )

	view = self.view

end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene