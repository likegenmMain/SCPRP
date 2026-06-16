local TweenService = game:GetService("TweenService")
local LocalPlayer = game.Players.LocalPlayer

local helicopterPos = Vector3.new(-75.98, 2.68, 893.22)
local speed = 40

local function doFarm()
    workspace.Gravity = 0
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local distance = (hrp.Position - helicopterPos).Magnitude
        local duration = distance / speed
        
        local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(helicopterPos)})
        tween:Play()
        tween.Completed:Wait()
        
        workspace.Gravity = 196.2
        task.wait(5)
        
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
        
        task.wait(3)
        
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.Health = 0 end
    end
end

while true do
    doFarm()
    task.wait(3)
end
