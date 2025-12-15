Editor = Object:extend()

local suit = require "libs.suit"
local input = {text = ""}
require "src.bone"

function Editor:new()
    self.state = FSM(self, self.creating)
end

function Editor:load()
    self.currentBoneId = 1
    self.skeleton = {
        position = Vec2.new(0, 0),
        bones = {
            Bone.new(nil, Vec2.new(100, 100), 100, 90),
        }
    }
end

function Editor:update(dt)
    self.state:update(dt)
end

function Editor:creating(dt)
    if Input.pressed("debug") then
        for _, bone in pairs(self.skeleton.bones) do
            print(bone.parent)
        end
    end

    if Input.pressed("rmb") then
        self:createBone()
    end

    if Input.down("rmb") then
        local last_bone = self.skeleton.bones[#self.skeleton.bones]
        last_bone.rotation = math.deg(math.atan2(Pushed_Mouse.y - last_bone.head.y, Pushed_Mouse.x - last_bone.head.x))
        last_bone:updateBone()
    end

    for _, bone in pairs(self.skeleton.bones) do
        -- print(bone.joint)
        -- bone.rotation = bone.rotation + 50 * dt
        bone:updateBone()
    end
end

function Editor:findClosestJoint()
    local distance = 9999999999999999999
    ---@type Bone
    local nearest_bone = nil
    ---@param bone Bone
    for _, bone in ipairs(self.skeleton.bones) do
        local distance_inbetween = Utils.distance(bone.joint.x, bone.joint.y, Pushed_Mouse.x, Pushed_Mouse.y)
        if distance_inbetween < distance then
            nearest_bone = bone
            distance = distance_inbetween
        end
    end
    print(nearest_bone.joint)
    return nearest_bone
end

function Editor:createBone()
    self.closest_bone = self:findClosestJoint()
    local bone = Bone.new(self.closest_bone, self.closest_bone.joint, 100, 0)
    table.insert(self.skeleton.bones, bone)
end

function Editor:draw()
    suit.draw()
    for _, bone in pairs(self.skeleton.bones) do
        bone:draw()
    end
end

function Editor:close()
end
