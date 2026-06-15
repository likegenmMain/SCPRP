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
        if not hrp:FindFirstChild("BodyPosition") then
            local bp = Instance.new("BodyPosition")
            bp.MaxForce = Vector3.new(math.huge, 0, math.huge)
            bp.P = 10000
            bp.D = 1000
            bp.Parent = hrp
        end
        hrp.BodyPosition.Position = hrp.Position + mv.Unit * 50 * 0.5
    end
end)
