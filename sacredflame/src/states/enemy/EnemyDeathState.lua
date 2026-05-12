
EnemyDeathState = Class{__includes = BaseState}

function EnemyDeathState:init(entity)
    self.entity = entity
end

function EnemyDeathState:enter(params)
    local playerDirection = self.entity.room.player.direction

    self.entity.direction = playerDirection == 'right' and 'left' or 'right'
    self.entity.body:setActive(false)
    self.entity:changeAnimation('death')

    if self.entity.fixture:getUserData().type == 'boss' then
        self.entity.dead = true

        Timer.after(10, function()
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()
                gStateStack:pop() -- pop play state
                gStateStack:push(VictoryState())
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1,
                function() end))
            end))
        end)
    end
end

function EnemyDeathState:processAI(params, dt)
end

function EnemyDeathState:update(dt)
    local anim = self.entity.currentAnimation
    if anim.timesPlayed > 0 then
        anim.timesPlayed = 0
        self.entity.dead = true
    end
end