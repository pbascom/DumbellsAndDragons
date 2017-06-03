--[[
		Initial Declarations
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local composer, json = require "composer", require "json"
local Encounter, Script, Region = require "lib.Encounter", require "lib.Script", require "lib.Region"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

-- Scene Variables & Forward Declarations
local sceneName, id = "The Long Stair", "stair"
local encounter, script, view, phase, params

local scene = composer.newScene()

-- Composer Lifecycle
function scene:create( event )
	view, params = self.view, event.params
	script = Script.new( id, params.class, params.level )
	encounter = Encounter.new( script, view )
	encounter:enterState( "INTRODUCTION" ); encounter:create( event )
end

function scene:show( event )
	phase = event.phase
	if phase == "will" then encounter.willShow( event )
	elseif phase == "did" then encounter.didShow( event ) end
end

function scene:hide( event )
	phase = event.phase
	if phase == "will" then encounter.willHide( event )
	elseif phase == "did" then encounter.didHide( event ) end
end

function scene:destroy( event )
	encounter.destroy()
	encounter = nil
	script = nil
end

scene:addEventListener( "create" )
scene:addEventListener( "show" )
scene:addEventListener( "hide" )
scene:addEventListener( "destroy" )

return scene