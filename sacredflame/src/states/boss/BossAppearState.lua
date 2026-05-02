BossAppearState = Class{__includes=BaseState}

function BossAppearState:init(entity)
    self.entity = entity
end

function BossAppearState:enter()
    self.entity:changeAnimation('appear')
end

function BossAppearState:update()

end