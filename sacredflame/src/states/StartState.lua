StartState = Class{__includes = BaseState}

function StartState:init()
    self.dialogBoxX = VIRTUAL_WIDTH / 4
    self.dialogBoxY = VIRTUAL_HEIGHT / 4
    self.dialogBoxWidth = VIRTUAL_WIDTH / 2 + 20
    self.dialogBoxHeight = 100

    self.startingDialogue = {
        "Hold [Q] to view controls at any time.",
        "Find enough before you face what waits below. You have 3 attempts...",
        "A torch burns above you, light it to save your progress and restore your strength...",
        "The sacred flame is dying. Brave warrior, descend into the temple depths and rekindle "
        .. "the torches before the darkness consumes what remains..."
    }
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateStack:push(FadeInState({
            r = 0, g = 0, b = 0
        }, 1,
        function()
            gStateStack:push(PlayState())

            for _, text in pairs(self.startingDialogue) do
                gStateStack:push(DialogueState("" ..
                    text,
                    self.dialogBoxX,
                    self.dialogBoxY,
                    self.dialogBoxWidth,
                    self.dialogBoxHeight
                ))
            end
            
            gStateStack:push(FadeOutState({
                r = 0, g = 0, b = 0
            }, 1,
            function() end))
        end))
        
    end
end

function StartState:render()
    -- draw the background
    love.graphics.setColor(255/255, 150/255, 50/255, 1)
    love.graphics.draw(gTextures['templeBg1'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    love.graphics.draw(gTextures['templeBg2'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    love.graphics.draw(gTextures['templeBg3'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    love.graphics.draw(gTextures['templeBg4'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)

    love.graphics.setFont(gFonts['title'])

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('The Sacred Flame', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['large'])
    
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.printf('Press Enter to start', 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')
end