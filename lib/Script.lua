--[[
		Setup
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local json = require "json"
local AI, DisplayManager = require "lib.AI", require "lib.DisplayManager"
local Region = require "lib.Region"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Script Object
--]]

local Script = {}

function Script.new( ai, dm, params )

	setmetatable( self, { __index = Script } )
	return self
end

return Script