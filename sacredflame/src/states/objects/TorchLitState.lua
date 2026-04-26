TorchLitState = Class{__includes = BaseState}

function TorchLitState:init(torch)
    self.torch = torch
end

function TorchLitState:enter()
    self.torch:changeAnimation('lit')
    self.torch.lit = true

    self:decreaseBossHealth()
end

function TorchLitState:decreaseBossHealth()
     local world = self.torch.body:getWorld()
    local bodies = world:getBodies()
    for _,body in pairs(bodies) do
        for _, fixture in pairs(body:getFixtures()) do
            if fixture:getUserData().type == 'boss' then
                local boss = fixture:getUserData().entity
                boss:damage()
            end
        end
    end
end

