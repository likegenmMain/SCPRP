local UserInputService = game:GetService("UserInputService")
local LocalPlayer = game.Players.LocalPlayer

UserInputService.JumpRequest:Connect(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z)
    end
end)
