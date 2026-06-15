local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = game.Players.LocalPlayer

RunService.Heartbeat:Connect(function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local look = Camera.CFrame.LookVector
    local right = Camera.CFrame.RightVector
    local mv = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv += Vector3.new(look.X, 0, look.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv -= Vector3.new(look.X, 0, look.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv -= Vector3.new(right.X, 0, right.Z).Unit end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv += Vector3.new(right.X, 0, right.Z).Unit end
    if mv.Magnitude > 0 then
        if not hrp:FindFirstChild("SpeedMotor") then
            local motor = Instance.new("Motor6D")
            motor.Name = "SpeedMotor"
            motor.Part0 = hrp
            motor.Part1 = hrp
            motor.Parent = hrp
        end
        hrp.CFrame = hrp.CFrame + mv.Unit * 50 * 0.01
    end
end)
