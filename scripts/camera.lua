---@class Camera
---@field zoom number
---@field target_zoom number
---@field target Vec2
---@field follow_speed number
---@field position Vec2
---@field shaking boolean
---@field offset  Vec2
---@field shake_pow number
---@field shake_calm_speed number
---@field update fun(self:Camera, dt:number)
---@field lock_on fun(self:Camera)
---@field shake fun(self:Camera, amount:number, speed:number)
---@field zoom_in fun(self:Camera, amount:number, speed:number)

Camera = {}
Camera.__index = Camera

---@return Camera
function Camera.new(zoom, target, follow_speed)
    local o = {}
    setmetatable(o, Camera)
    o.zoom = zoom
    o.target_zoom = zoom
    o.zoom_calm_speed = 5
    o.target = target or nil
    o.follow_speed = follow_speed or 2
    o.position = Vec2.new(0, 0)
    o.shaking = false
    o.limits = {
        left = -8,
        right = 8,
        top = 0,
        bottom = 0
    }

    if o.target then
        o.position.x = target.x - (WORLD_SIZE.WIDTH / 2) / o.zoom
        o.position.y = target.y - (WORLD_SIZE.HEIGHT / 2) / o.zoom
    end

    o.offset = Vec2.new(0, 0)
    o.shake_pow = 0
    o.shake_calm_speed = 5
    return o
end

function Camera:update(dt)
    self.limits.top = self.position.y - 9999
    self:follow(dt)
    self.offset.x = Lume.random(-self.shake_pow, self.shake_pow)
    self.offset.y = Lume.random(-self.shake_pow, self.shake_pow)
    self.shake_pow = Utils.lerp(self.shake_pow, 0, dt * self.shake_calm_speed)
    self.zoom = Utils.lerp(self.zoom, self.target_zoom, dt * self.zoom_calm_speed)
    self.zoom = Utils.lerp(self.zoom, self.target_zoom, dt * self.zoom_calm_speed)

    if self.shake_pow >= 5 then
        self.shaking = true
    else
        self.shaking = false
    end
end

function Camera:lock_on()
    local target_x = self.target.x - (WORLD_SIZE.WIDTH / 2) / self.zoom
    local target_y = self.target.y - (WORLD_SIZE.HEIGHT / 2) / self.zoom
    
    self.position.y = target_y
    self.position.x = target_x
end

function Camera:shake(amount, speed)
    self.shake_pow = amount or 500
    self.shake_calm_speed = speed or 2
end

function Camera:zoom_in(amount, speed)
    self.target_zoom = amount or 1
    self.zoom_calm_speed = speed or 2
end

function Camera:limit()
    self.position.x = math.max(self.limits.left, math.min(self.position.x, self.limits.right))
    self.position.y = math.max(self.limits.top, math.min(self.position.y, self.limits.bottom)) 
end

function Camera:follow(dt)
    if not self.target then return end

    local target_x = self.target.x - (WORLD_SIZE.WIDTH / 2) / self.zoom + self.offset.x
    local target_y = self.target.y - (WORLD_SIZE.HEIGHT / 2) / self.zoom + self.offset.y

    if self.shaking == false then
        self.position.y = Utils.lerp(self.position.y, target_y, dt * self.follow_speed * self.zoom)
        self.position.x = Utils.lerp(self.position.x, target_x, dt * self.follow_speed * self.zoom)
    else
        self.position.y = target_y
        self.position.x = target_x
    end

    self:limit()
end
