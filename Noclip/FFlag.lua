local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false; v.Massless = true end
        end
    end
end)
