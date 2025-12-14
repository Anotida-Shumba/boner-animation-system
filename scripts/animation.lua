---@class Animation
---@field animations table
---@field events table
---@field current_frame number
---@field current_animation string
---@field previous_animation string
---@field current_sprite Sprite
---@field flip Vec2
---@field scale Vec2
---@field rot number
---@field tick number
---@field looping boolean
---@field frame_duration number
---@field done boolean
---@field active boolean
---@field hide boolean
---@field add fun(self:Animation, path:string, name:string, frame_origin:Vec2|nil , center_origin:boolean|nil , offset:Vec2|nil)
---@field play fun(self:Animation, name:string, looping:boolean, frame_dur:number|nil, call:function|nil)
---@field animate fun(self:Animation, dt:number)
---@field pause fun(self:Animation)
---@field resume fun(self:Animation)
---@field add_event fun(self:Animation, anim_name:string, target_frame:number, callback:function)
---@field draw fun(self:Animation, pos:Vec2)
---@field update fun(self:Animation, dt:number)
---@field manual_tick fun(self:Animation, name:string, frame:number)

Animation = {}
Animation.__index = Animation

---@return Animation
function Animation.new()
    local o = {}
    setmetatable(o, Animation)

    o.animations = {}
    o.events = {}
    o.current_frame = 1
    o.current_animation = ""
    o.previous_animation = ""
    o.current_sprite = nil
    o.flip = Vec2.new(false, false)
    o.scale = Vec2.new(1, 1)
    o.rot = 0
    o.tick = 0
    o.looping = false
    o.frame_duration = 0.5
    o.done = false
    o.active = true
    o.hide = false
    return o
end

function Animation:update(dt)
    if self.active == false then
        return
    end

    self:aniamte(dt)

    for _, sync in ipairs(self.events) do
        local event = sync.call

        if sync.name == self.current_animation then
            if sync.frame == self.current_frame then
                event()
            end
        end
    end
end

function Animation:aniamte(dt)
    if Utils.is_in_list(self.animations, self.current_animation) then
        self.tick = self.tick + dt
        if self.tick > self.frame_duration then
            self.tick = 0
            local previous_frame = self.current_frame

            if self.looping then
                self.current_frame = (self.current_frame % #self.animations[self.current_animation]) + 1
            else
                self.current_frame = math.min(self.current_frame + 1, #self.animations[self.current_animation])
            end

            if self.current_frame ~= previous_frame then
                for _, sync in ipairs(self.events) do
                    if sync.name == self.current_animation and sync.frame == self.current_frame then
                        sync.call()
                    end
                end
            end
        end
    end
end

function Animation:add(path, name, frame_origin , center_origin , offset)
    local files = love.filesystem.getDirectoryItems(path)
    self.animations[name] = {}

    for _, value in ipairs(files) do
        local new_sprite = Sprite.new({
            image = path .. "/" .. value,
            origin = frame_origin or Vec2.new(0, 0),
            center_origin = center_origin or false,
            offset = offset or Vec2.new(0, 0)
        })
        table.insert(self.animations[name], new_sprite)
    end
end

function Animation:play(name , looping , frame_dur , call)
    if name == self.current_animation then
        return
    end

    if call ~= nil then
        call()
    end
    
    self.current_frame = 1
    self.previous_animation = self.current_animation
    self.current_animation = name
    self.looping = looping
    self.frame_duration = frame_dur or self.frame_duration

    if self.done == true then
        self.current_frame = 1
        self.done = false
    end
end

function Animation:manual_tick(name, frame)
    self.current_animation = name
    self.current_frame = frame
end

function Animation:pause()
    self.active = false
end

function Animation:resume()
    self.active = true
end

function Animation:restart(name , looping , frame_dur , call)
    if self.done == false then
        return
    end

    if call ~= nil then
        call()
    end
    
    self.current_frame = 1
    self.previous_animation = self.current_animation
    self.current_animation = name
    self.looping = looping
    self.frame_duration = frame_dur or self.frame_duration

    if self.done == true then
        self.current_frame = 1
        self.done = false
    end

end

function Animation:add_event(anim_name , target_frame , callback)
    table.insert(self.events , {call = callback , name = anim_name , frame = target_frame})
end

function Animation:draw(pos)
    if self.hide == true then
        return
    end

    if self.animations[self.current_animation] == nil then
        return
    end

    local current_sprite = self.animations[self.current_animation][self.current_frame]
    current_sprite.scale = Vec2.new(self.scale.x, self.scale.y)
    current_sprite.flip.x = self.flip.x
    current_sprite.flip.y = self.flip.y
    current_sprite.rot = math.rad(self.rot)
    
    -- Use parent's offset and pass to the sprite's draw method
    local draw_pos = Vec2.new(pos.x, pos.y)

    current_sprite:draw(draw_pos)
end
