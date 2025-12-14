---@class Vec2
---@field x number|boolean
---@field y number|boolean
Vec2 = {}
Vec2.__index = Vec2

function Vec2.__mul(a, b)
    if type(a) == "number"then
        return Vec2.new(b.x * a, b.y * a)
    end

    if type(b) == "number" then
        return Vec2.new(a.x * b, a.y * b)
    end

    return Vec2.new(a.x * b.x, a.y * b.y)
end

function Vec2.__div(a, b)
    if type(a) == "number"then
        return Vec2.new(b.x / a, b.y / a)
    end

    if type(b) == "number" then
        return Vec2.new(a.x / b, a.y / b)
    end

    return Vec2.new(a.x / b.x, a.y / b.y)
end

function Vec2.__add(a, b)
    return  Vec2.new(a.x + b.x, a.y + b.y)
end

function Vec2:__tostring()
    if type(self.x) == "number" or type(self.y) == "number" then
---@diagnostic disable-next-line: param-type-mismatch
        return "x " .. math.floor(self.x) .. " : " .. "y " .. math.floor(self.y)
    end

    return "x " .. self.x .. " : " .. "y " .. self.y
end

function Vec2.new(x, y)
    local o = {}
    setmetatable(o, Vec2)

    o.x = x
    o.y = y
    return o
end

function Color(r, g, b, a)
    if type(r) == "string" then
        local hex = r:gsub("#", "") -- Remove # if present
        local red = tonumber(hex:sub(1, 2), 16) / 255
        local green = tonumber(hex:sub(3, 4), 16) / 255
        local blue = tonumber(hex:sub(5, 6), 16) / 255
        local alpha = g ~= nil and g or 1
        return {red , green , blue , alpha}
    end

    local red = r ~= nil and r/255 or 1
    local green = g ~= nil and g/255 or 1
    local blue = b ~= nil and b/255 or 1
    local alpha = a ~= nil and a/255 or 1

    return {red , green , blue , alpha}
end