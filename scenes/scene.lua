Scene = Object:extend()

function Scene:new()
    self.state = FSM(self, self.idle)
end

function Scene:load()
   Input.bind("a", "left")
   Input.bind("gamepad:triggerleft", "shoot")
end

function Scene:update(dt)

end

function Scene:cam_control(dt)

end

function Scene:idle(dt)
    

end

function Scene:close()

end

function Scene:draw()

end
