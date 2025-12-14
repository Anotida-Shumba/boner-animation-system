Object = require "libs.classic"
Utils = require "libs.utils"
Push = require "libs.push"
Lume = require "libs.lume"
Event = require "libs.event"
require "libs.console"
require "game"
Terminal = Console({ size = 8 })

local scripts = love.filesystem.getDirectoryItems("scripts")
for _, value in ipairs(scripts) do
    require("scripts." .. value:sub(1, -5))
end

local scenes = love.filesystem.getDirectoryItems("scenes")
for _, value in ipairs(scenes) do
    require("scenes." .. value:sub(1, -5))
end

WORLD_SIZE = { WIDTH =  640, HEIGHT = 360}
local desktopWidth, desktopHeight = love.graphics.getDimensions()
WINDOW_WIDTH, WINDOW_HEIGHT = desktopWidth * 0.7, desktopHeight * 0.7

Push:setupScreen(WORLD_SIZE.WIDTH, WORLD_SIZE.HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { fullscreen = false, resizable = true})
Push:switchFullscreen()
Push:switchFullscreen()
Push._borderColor = Color("000000")

Pushed_Mouse = { x = 0, y = 0, real_x = 0, real_y = 0}

function Log(message)
    Terminal:print(message)
end

require "bindings"