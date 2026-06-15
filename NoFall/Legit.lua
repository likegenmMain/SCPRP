local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if hrp.Velocity.Y >= 0 then return end
    
    local ray = Ray.new(hrp.Position, Vector3.new(0, -500, 0))
    local hit = workspace:FindPartOnRay(ray, char)
    if hit then
        local dist = (hrp.Position - hit.Position).Magnitude
        if dist <= 10 then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y / 3, hrp.Velocity.Z)
        end
    end
end)
