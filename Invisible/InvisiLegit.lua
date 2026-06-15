local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

local invisEnabled = false
local invisConnection = nil
local platform = nil

local function toggleInvisibility()
    invisEnabled = not invisEnabled
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    
    if invisEnabled then
        platform = Instance.new("Part")
        platform.Size = Vector3.new(10, 1, 10)
        platform.Anchored = true
        platform.Transparency = 1
        platform.Parent = workspace
        
        invisConnection = RunService.Heartbeat:Connect(function()
            if not invisEnabled then return end
            local char = LocalPlayer.Character
            if not char or not platform then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                platform.Position = Vector3.new(hrp.Position.X, -20, hrp.Position.Z)
                hrp.CFrame = CFrame.new(hrp.Position.X, -17, hrp.Position.Z)
            end
        end)
    else
        if invisConnection then invisConnection:Disconnect() invisConnection = nil end
        if platform then platform:Destroy() platform = nil end
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + 25, hrp.Position.Z)
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then toggleInvisibility() end
end)
