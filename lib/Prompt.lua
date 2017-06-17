local data, theme = require "lib.data", require "lib.theme"
local fn, fx, ui = require "lib.fn", require "lib.fx", require "lib.ui"
local Region, Action, Behavior = require "lib.Region", require "lib.Action", require "lib.Behavior"
local xn, yn, xo, yo, xf, yf = unpack( data.co )

local Prompt = {}
local PromptMT = { __index = Prompt }

function Prompt.new()
	local self = {}
	setmetatable( self, PromptMT )
	return self
end

function Prompt.introduce()