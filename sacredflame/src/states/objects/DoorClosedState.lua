DoorClosedState = Class{__includes = BaseState}

function DoorClosedState:init(door)
    self.door = door
end

function DoorClosedState:enter()
    self.door:changeAnimation('closed')
end
