--[[
		Setup
--]]


-- Requirements
local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local json = require "json"
local AI, DisplayManager = require "lib.AI", require "lib.DisplayManager"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

--[[
		Script Object
--]]

local Script = {}

function Script.new( id, class, level )
	local self = {
		id = id,
		class = class,
		level = level,
	}

	function self:checkAgainst( inputString )
		local firstChar = string.sub( inputString, 1, 1 )

		if toNumber( firstChar ) ~= nil && toNumber( firstChar ) <= 9 then
			local secondChar = string.sub( inputString, 2, 2 )
			if secondChar == nil then
				return self.level == toNumber( firstChar )
			elseif secondChar == "+" then
				return self.level >= toNumber( firstChar )
			elseif secondChar == "-" then
				return self.level <= toNumber( firstChar )
			else
				local thirdChar = string.sub( inputString, 3, 3 )
				local checkString = string.sub( inputString, 1, 2 )
				if thirdChar == nil then
					return self.level == toNumber( checkString )
				elseif thirdChar == "+" then
					return self.level >= toNumber( checkString )
				elseif thirdChar == "-" then
					return self.level <= toNumber( checkString )
				end
			end
		else
			return self.class == inputString
		end
	end

	function self:loadMods()


	-- Replace with fn.getFile once we have a preferred method set up
	local path = system.pathForFile( "" .. id .. ".json", system.DocumentsDirectory )
	local sourceFile, errorString = io.open( path, "r" )
	local source = json.decode( sourceFile:read( "*a" ) )
	io.close()

	self.info = source.info
	for key, value in pairs( source.mods ) do
		local useMod = true
		for term in string.gmatch( key, "%s+" ) do
			if not self:checkAgainst( term ) then useMod = false end
		end
		if useMod then
			for k, v in pairs( value ) do
				self.info[k] = v
			end
		end
	end

	setmetatable( self, { __index = Script } )
	return self
end

function Script:getSplashScreenParameters()
	return {
		id = self.id,
		description = self.info.description,
		duration = self.info.duration,
		equipment = self.info.equipment
	}
end

return Script