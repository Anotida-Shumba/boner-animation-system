---@class Timer
---@field duration number
---@field callback function|nil
---@field elapsed number
---@field active boolean
---@field done boolean
---@field update fun(self:Timer, dt:number)
---@field start fun(self:Timer, dur:number, call:function|nil)
---@field stop fun(self:Timer)
---@field restart fun(self:Timer)
---@field stop_all fun(self:Timer)


Timer = {}
Timer.__index = Timer

Timer.timers = {}

---@return Timer
function Timer.new()
    local o = {}
    setmetatable(o, Timer)
    o.duration = 1
    o.callback = nil
    o.elapsed = 0
    o.active = false
    o.done = false
    table.insert(Timer.timers , o)
    return o
end

-- Update the timer
function Timer:update(dt)
    if self.active == true then
        -- Terminal:print(self.elapsed)
        self.elapsed = self.elapsed + dt
        if self.elapsed >= self.duration then
            if self.callback then
                self.callback()
            end
            self.active = false
            self.done = true
        end
    end
end

function Timer:start(dur , call)
    if self.active == true then
        return
    end
    self.active = true
    self.elapsed = 0
    self.duration = dur
    self.callback = call
    self.done = false
end

function Timer:stop()
    self.elapsed = 0
    self.callback = nil
    self.dur = 0
    self.done = false
    self.active = false
end

function Timer:restart()
    self.active = true
    self.elapsed = 0
    self.done = false
end

function Timer.stop_all()
    for index, timer in ipairs(Timer.timers) do
        timer:stop()
    end
end