local composer, json = require("composer", "json")
local Encounter
do
  local _class_0
  local _base_0 = { }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.scene = composer.newScene()
      self.scene.create = function(self, event)
        local view = self.view
        return print("create")
      end
      self.scene.show = function(self, event)
        local view, phase = self.view, self.phase
        if phase == "will" then
          return print("show; will")
        elseif phase == "did" then
          return print("show; did")
        end
      end
      self.scene.hide = function(self, event)
        local view, phase = self.view, self.phase
        if phase == "will" then
          return print("hide; will")
        elseif phase == "did" then
          return print("hide; did")
        end
      end
      self.scene.destroy = function(self, event)
        local view = self.view
        return print("destroy")
      end
      self.scene:addEventListener("create", self.scene)
      self.scene:addEventListener("show", self.scene)
      self.scene:addEventListener("hide", self.scene)
      self.scene:addEventListener("destroy", self.scene)
      return self
    end,
    __base = _base_0,
    __name = "Encounter"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Encounter = _class_0
end
return Encounter
