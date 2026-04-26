TorchUnlitState = Class{__includes = BaseState}

function TorchUnlitState:init(torch)
    self.torch = torch
end

function TorchUnlitState:enter()
    self.torch:changeAnimation('unlit')
end
