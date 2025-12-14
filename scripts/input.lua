---@class input
--numbers 1 through 3 are reserved for mouse clicks
--5 is up scroll and 4 is down scroll
--gamepad inputs are prefixed with gamepad:
local input = {
    bindings = {},
    state = {},
    axes = {},
    joysticks = love.joystick.getJoysticks()
}

input.bind = function (key, action)
    input.bindings[key] = action
    input.state[action] = {pressed = false, down = false, released = false}
end

input.pressed = function (action)
    return input.state[action] and input.state[action].pressed
end

input.down = function (action)
    return input.state[action] and input.state[action].down
end

input.released = function (action)
    return input.state[action] and input.state[action].released
end

input.updateAxes = function ()
    for _, joystick in ipairs(input.joysticks) do
        for _, axis in ipairs({"leftx","lefty","rightx","righty","triggerright","triggerleft"}) do
            local val = joystick:getGamepadAxis(axis)
            local action = input.bindings["gamepad:"..axis]
            if action then
                input.axes[action] = val
            end
        end
    end
end

input.update = function ()
    -- print(Input.state["jump"].down)
    for _, action in pairs(input.state) do
        action.pressed = false
        action.released = false
    end

    input.updateAxes()
end

function input.getAxis(bind_a, bind_b)
    if input.down(bind_a) then
        return -1
    end
    if input.down(bind_b) then
        return 1
    end
    return 0
end

return input