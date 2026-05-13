DoorOpenState = Class{__includes = BaseState}

function DoorOpenState:init(door)
    self.door = door
end

function DoorOpenState:enter()
    self.door:changeAnimation('open')
end

function DoorOpenState:update(dt)

    local currAnimation = self.door.currentAnimation
    if not currAnimation then
        return
    end

    if currAnimation:getCurrentFrame() == 9 then
        self.door.open = true
    end
end