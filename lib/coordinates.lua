local data, theme = require "lib.data"
local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY

data.co = { xn - width/2 , yn - height/2 , xn, yn, xn + width/2, yn + height/2 }