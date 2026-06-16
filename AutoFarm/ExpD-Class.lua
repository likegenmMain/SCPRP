local TweenService = game:GetService("TweenService")
local LocalPlayer = game.Players.LocalPlayer

local startPos = Vector3.new(-75.98, 2.68, 843.22)
local endPos = Vector3.new(-75.98, 2.68, 893.22)
local speed = 40

local function doFarm()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    workspace.Gravity = 0
    
    local dist1 = (hrp.Position - startPos).Magnitude
    local tween1 = TweenService:Create(hrp, TweenInfo.new(dist1 / speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(startPos)})
    tween1:Play()
    tween1.Completed:Wait()
    
    local dist2 = (startPos - endPos).Magnitude
    local tween2 = TweenService:Create(hrp, TweenInfo.new(dist2 / speed, Enum.EasingStyle.Linear), {CFrame = CFrame.new(endPos)})
    tween2:Play()
    tween2.Completed:Wait()
    
    workspace.Gravity = 196.2
    task.wait(8)
    
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
    if hum then hum.Health = 0 end
end

while true do
    doFarm()
end
