---@class Bone
---@field id number
---@field parent Bone|nil
---@field head Vec2
---@field length number
---@field rotation number
---@field joint Vec2
---@field updateBone fun(self:Bone)
---@field draw fun(self:Bone)


Bone = {}
Bone.__index = Bone

Bone.Bone = {}

---@return Bone
function Bone.new(parent, position, length, rotation)
    local o = {}
    setmetatable(o, Bone)
    o.id = 1
    o.parent = parent or nil
    o.head = position
    o.length = length
    o.rotation = rotation
    o.joint = position + Vec2.new(math.cos(math.rad(rotation)) * length, math.sin(math.rad(rotation)) * length)
    table.insert(Bone.Bone , o)
    return o
end

function Bone:updateBone()
    self.joint = self.head + Vec2.new(math.cos(math.rad(self.rotation)) * self.length, math.sin(math.rad(self.rotation)) * self.length)
end

function Bone:draw()
    love.graphics.line(self.head.x, self.head.y, self.joint.x, self.joint.y)
    love.graphics.circle("fill", self.head.x, self.head.y, 10)
    love.graphics.circle("fill", self.joint.x, self.joint.y, 10)
end