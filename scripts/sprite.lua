---@class params
---@field rot number
---@class Sprite
---@field flip Vec2
---@field rot number
---@field image nil
---@field offset Vec2
---@field scale Vec2
---@field width number
---@field height number
---@field origin Vec2
---@field mirror_rotation boolean
---@field debug boolean
---@field draw fun(self: Sprite, pos: Vec2)

Sprite = {}
Sprite.__index = Sprite

---@param params table[image, scale, flip, rot, offset, origion, mirrored_rotation]
---@return Sprite
function Sprite.new(params)
    local o = {}
    setmetatable(o , Sprite)
    o.flip = params.flip or Vec2.new(false, false)
    o.rot = params.rot or 0
    o.image = love.graphics.newImage(params.image)
    o.offset = params.offset or Vec2.new(0, 0)
    o.scale = params.scale or Vec2.new(1, 1)
    o.width = o.image:getWidth()
    o.height = o.image:getHeight()
    o.origin = params.origin or Vec2.new(0, 0)
    o.mirror_rotation = params.mirror_rotation or false 
    o.debug = false
    return o
end

function Sprite:draw(pos)
    local offset = Vec2.new(self.offset.x, self.offset.y)
    local direction = Vec2.new(self.flip.x and -1 or 1, self.flip.y and -1 or 1)
    if self.mirror_rotation then
        offset.x = offset.x * direction.x
        offset.y = offset.y * direction.y
    end

    -- Determine the rotation
    local rotation = self.rot
    if self.mirror_rotation then
        rotation = rotation * direction.x * direction.y
    end

    local draw_pos = Vec2.new(pos.x + offset.x, pos.y + offset.y)

    -- Draw the sprite with proper origin for transformations
    love.graphics.draw(
        self.image,
        draw_pos.x,
        draw_pos.y,
        rotation,
        self.scale.x * direction.x,
        self.scale.y * direction.y,
        self.origin.x,
        self.origin.y
    )

    if self.debug == true then
        love.graphics.circle("fill", pos.x, pos.y, 5)
        love.graphics.rectangle("line", pos.x, pos.y, self.width * self.scale.x, self.height * self.scale.y)
    end
end