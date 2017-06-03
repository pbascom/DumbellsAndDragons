local data = {}

local width, height, xn, yn = display.actualContentWidth, display.actualContentHeight, display.contentCenterX, display.contentCenterY
data.co = { xn, yn, xn - width/2 , yn - height/2, xn + width/2, yn + height/2 }

return data