local input = require "scripts.input"

---@class Game
Game = Object:extend()

local font = love.graphics.newFont("assets/fonts/jetbrains.ttf", 32)

function Game:new()
   self.state = FSM(self , self.play_state)
   local scenes = {
      ["scene"] = Scene()
   }
   self.scene_manager = SceneManager(scenes)
   self.scene_manager:load("scene")
end

function Game:update(dt)
   self.state:update(dt)
   self.scene_manager:update(dt)
   if Input.pressed("debug") then
      self.debug = not self.debug
   end
end

function Game:play_state(dt)

end

function Game:draw()
   love.graphics.setFont(font)
   self.scene_manager:draw()
   if self.debug then
      love.graphics.print("x : "..math.floor(Pushed_Mouse.x).." : y : "..math.floor(Pushed_Mouse.y), Pushed_Mouse.x, Pushed_Mouse.y)
   end
end
