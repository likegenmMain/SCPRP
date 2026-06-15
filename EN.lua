local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "SCPRP | Rewrite",
    Footer = "by Likegenm",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

Library.ToggleKeybind = Enum.KeyCode.RightControl

local Tabs = {
    Blatant = Window:AddTab("Blatant", "swords"),
    Visual = Window:AddTab("Visual", "eye"),
}

local BlatantGroup = Tabs.Blatant:AddLeftGroupbox("Movement")

local speedMethod = "SeatSeek"
local speedValue = 30
local speedEnabled = false
local speedConnection = nil

local infJumpsEnabled = false
local infJumpsConnection = nil

local noFallEnabled = false
local noFallConnection = nil

local noclipEnabled = false
local noclipMethod = "Character"
local noclipConnection = nil

local invisEnabled = false
local invisConnection = nil
local invisPlatform = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

BlatantGroup:AddDropdown("SpeedMethod", {
    Text = "Speed Method",
    Values = { "SeatSeek", "CFrame", "Motor" },
    Default = "SeatSeek",
    Callback = function(Value) speedMethod = Value end,
})

BlatantGroup:AddSlider("SpeedValue", {
    Text = "Speed Value",
    Default = 30,
    Min = 16,
    Max = 40,
    Rounding = 0,
    Callback = function(Value) speedValue = Value end,
})

local function speedLoop()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local look = Camera.CFrame.LookVector
    local right = Camera.CFrame.RightVector
    local mv = Vector3.zero
    
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Vector3.new(look.X, 0, look.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Vector3.new(look.X, 0, look.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Vector3.new(right.X, 0, right.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Vector3.new(right.X, 0, right.Z).Unit end
    
    if mv.Magnitude > 0 then
        if speedMethod == "SeatSeek" then
            hrp.CFrame = hrp.CFrame + mv.Unit * speedValue * 0.01
        elseif speedMethod == "CFrame" then
            hrp.CFrame = hrp.CFrame + mv.Unit * 0.5
        elseif speedMethod == "Motor" then
            if not hrp:FindFirstChild("SpeedMotor") then
                local motor = Instance.new("Motor6D")
                motor.Name = "SpeedMotor"
                motor.Part0 = hrp
                motor.Part1 = hrp
                motor.Parent = hrp
            end
            hrp.CFrame = hrp.CFrame + mv.Unit * speedValue * 0.01
        end
    end
end

local function noclipLoop()
    if not noclipEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    if noclipMethod == "Character" then
        for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
    elseif noclipMethod == "FFlag" then
        for _, v in ipairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false v.Massless = true end end
    end
end

BlatantGroup:AddDropdown("NoclipMethod", {
    Text = "Noclip Method",
    Values = { "Character", "FFlag" },
    Default = "Character",
    Callback = function(Value) noclipMethod = Value end,
})

BlatantGroup:AddToggle("SpeedEnabled", {
    Text = "Speed Hack",
    Default = false,
    Callback = function(Value)
        speedEnabled = Value
        if Value then speedConnection = RunService.Heartbeat:Connect(speedLoop)
        else if speedConnection then speedConnection:Disconnect() speedConnection = nil end end
    end,
})

BlatantGroup:AddToggle("InfJumpsEnabled", {
    Text = "Inf Jumps",
    Default = false,
    Callback = function(Value)
        infJumpsEnabled = Value
        if Value then
            infJumpsConnection = UserInputService.JumpRequest:Connect(function()
                local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.Velocity = Vector3.new(hrp.Velocity.X, 50, hrp.Velocity.Z) end
            end)
        else if infJumpsConnection then infJumpsConnection:Disconnect() infJumpsConnection = nil end end
    end,
})

BlatantGroup:AddToggle("NoFallEnabled", {
    Text = "No Fall",
    Default = false,
    Callback = function(Value)
        noFallEnabled = Value
        if Value then
            noFallConnection = RunService.Heartbeat:Connect(function()
                local char = LocalPlayer.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                if hrp.Velocity.Y >= 0 then return end
                local ray = Ray.new(hrp.Position, Vector3.new(0, -500, 0))
                local hit = workspace:FindPartOnRay(ray, char)
                if hit then
                    local dist = (hrp.Position - hit.Position).Magnitude
                    if dist > 10 and dist <= 30 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y / 1.5, hrp.Velocity.Z)
                    elseif dist <= 10 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, hrp.Velocity.Y / 3, hrp.Velocity.Z)
                    end
                end
            end)
        else if noFallConnection then noFallConnection:Disconnect() noFallConnection = nil end end
    end,
})

BlatantGroup:AddToggle("NoclipEnabled", {
    Text = "Noclip",
    Default = false,
    Callback = function(Value)
        noclipEnabled = Value
        if Value then noclipConnection = RunService.Heartbeat:Connect(noclipLoop)
        else if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end end
    end,
})

BlatantGroup:AddToggle("InvisEnabled", {
    Text = "Invisible",
    Default = false,
    Callback = function(Value)
        invisEnabled = Value
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        
        if invisEnabled then
            invisPlatform = Instance.new("Part")
            invisPlatform.Size = Vector3.new(10, 1, 10)
            invisPlatform.Anchored = true
            invisPlatform.Transparency = 1
            invisPlatform.Parent = workspace
            
            invisConnection = RunService.Heartbeat:Connect(function()
                if not invisEnabled then return end
                local char = LocalPlayer.Character
                if not char or not invisPlatform then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    invisPlatform.Position = Vector3.new(hrp.Position.X, -20, hrp.Position.Z)
                    hrp.CFrame = CFrame.new(hrp.Position.X, -17, hrp.Position.Z)
                end
            end)
        else
            if invisConnection then invisConnection:Disconnect() invisConnection = nil end
            if invisPlatform then invisPlatform:Destroy() invisPlatform = nil end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y + 25, hrp.Position.Z)
            end
        end
    end,
})
