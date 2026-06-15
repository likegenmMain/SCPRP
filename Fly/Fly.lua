local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

local flyEnabled = false
local flySpeed = 50

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        flyEnabled = not flyEnabled
        if flyEnabled then
            RunService.Heartbeat:Connect(function()
                if not flyEnabled then return end
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local verticalVel = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    verticalVel = flySpeed
                elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) then
                    verticalVel = -flySpeed
                end
                
                hrp.Velocity = Vector3.new(hrp.Velocity.X, verticalVel, hrp.Velocity.Z)
            end)
        end
    end
end)
