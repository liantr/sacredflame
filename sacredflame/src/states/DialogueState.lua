--[[
    CS50 2D
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Extension: Changed position and dimensions of the box
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, x, y, w, h, callback)
    self.textbox = Textbox(x, y, w, h, text, gFonts['small'])
    self.callback = callback or function() end
end

function DialogueState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        self.callback()
        gStateStack:pop()
    end
end

function DialogueState:render()
    self.textbox:render()
end