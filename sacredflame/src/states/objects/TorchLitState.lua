TorchLitState = Class{__includes = BaseState}

function TorchLitState:init(torch)
    self.torch = torch
end

function TorchLitState:enter()
    self.torch:changeAnimation('lit')
    self.torch.lit = true
end
