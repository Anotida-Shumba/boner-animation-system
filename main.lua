if arg[2] == "debug" then
    require("lldebugger").start()
end

love.graphics.setDefaultFilter("nearest", "nearest")
math.randomseed(os.clock() * 100000000000)
require "settings"
local game

function love.load()
    game = Game()
end

local function update_mouse_position()
    local mouse_x, mouse_y = love.mouse.getPosition()
    local game_x, game_y = Push:toGame(mouse_x, mouse_y)

    if game_x and game_y then
        Pushed_Mouse.x, Pushed_Mouse.y = game_x, game_y
        Pushed_Mouse.real_x, Pushed_Mouse.real_y = Push:toGame(mouse_x, mouse_y)
    end
end

function love.update(dt)
    game:update(dt)
    Input.update()
    update_mouse_position()
end

function love.mousepressed(x, y, button)
    local action = Input.bindings[button]
    if action then
        Input.state[action].pressed = true
        Input.state[action].down = true
    end
end

function love.mousemoved( x, y, dx, dy, istouch )
    
end

function love.mousereleased(x, y, button)
    local action = Input.bindings[button]
    if action then
        Input.state[action].released = true
        Input.state[action].down = false
    end
end

function love.wheelmoved(x, y)
    local scroll_direction = y > 0 and 5 or y < 0 and 4
    local action = Input.bindings[scroll_direction]
    if action then
        Input.state[action].pressed = true
    end
end

function love.keypressed(key)
    local action = Input.bindings[key]
    if action then
        Input.state[action].pressed = true
        Input.state[action].down = true
    end
end

function love.keyreleased(key)
    local action = Input.bindings[key]
    if action then
        Input.state[action].released = true
        Input.state[action].down = false
    end
end

function love.gamepadpressed(joystick, button)
    Input.active_gamepad = joystick
    local action = Input.bindings["gamepad:"..button]
    if action then
        Input.state[action] = Input.state[action] or {}
        Input.state[action].pressed = true
        Input.state[action].down = true    
    end
end

function love.gamepadreleased(joystick, button)
    local action = Input.bindings["gamepad:"..button]
    if action then
        Input.state[action].released = true
        Input.state[action].down = false
        
    end
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.draw()
    Push:start()
    love.graphics.setColor(Color("000000"))
    love.graphics.rectangle("fill", 0, 0, WORLD_SIZE.WIDTH, WORLD_SIZE.HEIGHT)
    love.graphics.setColor(Color())
    game:draw()
    Push:finish()
    Terminal:draw()
end