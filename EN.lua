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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

BlatantGroup:AddDropdown("SpeedMethod", {
    Text = "Speed Method",
    Values = { "SeatSeek", "CFrame", "BodyPosition", "Motor" },
    Default = "SeatSeek",
    Callback = function(Value)
        speedMethod = Value
    end,
})

BlatantGroup:AddSlider("SpeedValue", {
    Text = "Speed Value",
    Default = 30,
    Min = 16,
    Max = 40,
    Rounding = 0,
    Callback = function(Value)
        speedValue = Value
    end,
})

local function cleanup()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if hrp:FindFirstChild("BodyPosition") then hrp.BodyPosition:Destroy() end
            for _, v in ipairs(hrp:GetChildren()) do
                if v:IsA("Motor6D") and v.Name == "SpeedMotor" then v:Destroy() end
            end
        end
    end
end

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
        elseif speedMethod == "BodyPosition" then
            if not hrp:FindFirstChild("BodyPosition") then
                local bp = Instance.new("BodyPosition")
                bp.MaxForce = Vector3.new(math.huge, 0, math.huge)
                bp.P = 10000
                bp.D = 1000
                bp.Parent = hrp
            end
            hrp.BodyPosition.Position = hrp.Position + mv.Unit * speedValue * 0.5
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

BlatantGroup:AddToggle("SpeedEnabled", {
    Text = "Speed Hack",
    Default = false,
    Risky = true,
    Callback = function(Value)
        speedEnabled = Value
        if Value then
            speedConnection = RunService.Heartbeat:Connect(speedLoop)
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
            cleanup()
        end
    end,
})
