PauseState = Class{__includes = BaseState}

function PauseState:init()

    self.options = { 'Resume Game', 'Quit' }
    self.selectedOption = 1
end

function PauseState:enter(params)
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}

    self.playState = params.playState
end

function PauseState:update(dt)

    if love.keyboard.wasPressed('up') then
        self.selectedOption = math.max(1, self.selectedOption - 1)
    end

    if love.keyboard.wasPressed('down') then
        self.selectedOption = math.min(#self.options, self.selectedOption + 1)
    end

    if love.keyboard.wasPressed('return') then
        if self.selectedOption == 1 then
            gStateMachine:change('play', {playState = self.playState})
        elseif self.selectedOption == 2 then
            love.event.quit()
        end
    end
    if love.keyboard.wasPressed('p') then
        gStateMachine:change('play', {playState = self.playState})
    end

    print(tostring(self.selectedOption))
end

function PauseState:render()
    self.playState:render()
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle('fill',0,0,VIRTUAL_WIDTH,VIRTUAL_HEIGHT)

    love.graphics.setFont(gFonts['large'])

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Paused', 0, VIRTUAL_HEIGHT / 2 - 80, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])

    local y = VIRTUAL_HEIGHT / 2 - 10
    for k, option in ipairs(self.options) do
        if k == self.selectedOption then
            love.graphics.setColor(1, 0.6, 0.2, 1)
        else
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.printf(option, 0, y, VIRTUAL_WIDTH, 'center')
        y = y + 30
    end
    
    love.graphics.setColor(1, 1, 1, 1)
end