GameOverState = Class{__includes = BaseState}

function GameOverState:init()
end

function GameOverState:enter()
    Timer.after(3, function()

        gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()

                
                gStateStack:pop() -- pops the game over state
                gStateStack:pop() -- pops the play state
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1,
                function() end))
            end))
    end)
end

function GameOverState:update(dt)
end

function GameOverState:render()
    -- draw the background
    love.graphics.setColor(255/255, 150/255, 50/255, 1)
    love.graphics.draw(gTextures['templeBg1'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    love.graphics.draw(gTextures['templeBg2'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    love.graphics.draw(gTextures['templeBg3'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    love.graphics.draw(gTextures['templeBg4'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)

    love.graphics.setFont(gFonts['title'])

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('GameOver', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    
    love.graphics.setColor(1, 1, 1, 1)
end