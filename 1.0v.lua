-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- Clean up existing GUI if already loaded
if CoreGui:FindFirstChild("AdminHubGUI") then
    CoreGui.AdminHubGUI:Destroy()
end

-- Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminHubGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Try to parent to CoreGui, fallback to PlayerGui
local success = pcall(function()
    screenGui.Parent = CoreGui
end)
if not success then
    screenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Toggle Button (.)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleMenuButton"
toggleBtn.Size = UDim2.new(0, 40, 0, 40)
toggleBtn.Position = UDim2.new(0, 20, 0, 100)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
toggleBtn.BorderSizePixel = 2
toggleBtn.Text = "."
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 28
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

-- Main Window Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 320, 0, 300)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Top Bar (Title & Window Controls)
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 35)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 10)
topBarCorner.Parent = topBar

-- Fix top corners rounding leaking
local topBarFix = Instance.new("Frame")
topBarFix.Size = UDim2.new(1, 0, 0, 10)
topBarFix.Position = UDim2.new(0, 0, 1, -10)
topBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBarFix.BorderSizePixel = 0
topBarFix.Parent = topBar

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Admin Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

-- Container for Control Buttons (X, -, [])
local controlsContainer = Instance.new("Frame")
controlsContainer.Size = UDim2.new(0, 105, 1, 0)
controlsContainer.Position = UDim2.new(1, -105, 0, 0)
controlsContainer.BackgroundTransparency = 1
controlsContainer.Parent = topBar

local uiLayout = Instance.new("UIListLayout")
uiLayout.FillDirection = Enum.FillDirection.Horizontal
uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
uiLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0, 4)
uiLayout.Parent = controlsContainer

-- Helper function to create window buttons
local function createWindowButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 28, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = btn
    
    btn.Parent = controlsContainer
    return btn
end

local minimizeBtn = createWindowButton("-", 1)
local expandBtn = createWindowButton("[]", 2)
local closeBtn = createWindowButton("X", 3)

-- Content Container
local contentContainer = Instance.new("ScrollingFrame")
contentContainer.Name = "Content"
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.BorderSizePixel = 0
contentContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
contentContainer.ScrollBarThickness = 4
contentContainer.Parent = mainFrame

local contentLayout = Instance.new("UIListLayout")
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Padding = UDim.new(0, 8)
contentLayout.Parent = contentContainer

-- Function to create feature toggle buttons
local function createFeatureToggle(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.BorderSizePixel = 0
    btn.Text = "  " .. name .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.LayoutOrder = order
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.Parent = contentContainer
    return btn
end

local godmodeBtn = createFeatureToggle("God Mode", 1)
local noclipBtn = createFeatureToggle("Noclip", 2)
local flyBtn = createFeatureToggle("Fly", 3)
local speedBtn = createFeatureToggle("Speedhack (50)", 4)
local jumpBtn = createFeatureToggle("Jumphack (100)", 5)

-- State variables
local states = {
    Godmode = false,
    Noclip = false,
    Fly = false,
    Speed = false,
    Jump = false
}

-- Feature implementations
-- 1. God Mode
local godmodeConnection
godmodeBtn.MouseButton1Click:Connect(function()
    states.Godmode = not states.Godmode
    if states.Godmode then
        godmodeBtn.Text = "  God Mode: ON"
        godmodeBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
        godmodeConnection = RunService.Stepped:Connect(function()
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    else
        godmodeBtn.Text = "  God Mode: OFF"
        godmodeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        if godmodeConnection then godmodeConnection:Disconnect() end
    end
end)

-- 2. Noclip
local noclipConnection
noclipBtn.MouseButton1Click:Connect(function()
    states.Noclip = not states.Noclip
    if states.Noclip then
        noclipBtn.Text = "  Noclip: ON"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
        noclipConnection = RunService.Stepped:Connect(function()
            if character then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        noclipBtn.Text = "  Noclip: OFF"
        noclipBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        if noclipConnection then noclipConnection:Disconnect() end
    end
end)

-- 3. Fly
local flyConnection
local bv, bg
flyBtn.MouseButton1Click:Connect(function()
    states.Fly = not states.Fly
    if states.Fly then
        flyBtn.Text = "  Fly: ON"
        flyBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
        
        local camera = workspace.CurrentCamera
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = humanoidRootPart
        
        bg = Instance.new("BodyGyro")
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.CFrame = camera.CFrame
        bg.Parent = humanoidRootPart
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if not character or not humanoidRootPart then return end
            bg.CFrame = camera.CFrame
            local moveDir = humanoid.MoveDirection
            if moveDir.Magnitude > 0 then
                bv.Velocity = camera.CFrame.LookVector * (moveDir.Z * 50) + camera.CFrame.RightVector * (moveDir.X * 50) + Vector3.new(0, moveDir.Y * 50, 0)
            else
                bv.Velocity = Vector3.new(0, 0, 0)
            end
        end)
    else
        flyBtn.Text = "  Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        if flyConnection then flyConnection:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- 4. Speedhack
speedBtn.MouseButton1Click:Connect(function()
    states.Speed = not states.Speed
    if states.Speed then
        speedBtn.Text = "  Speedhack (50): ON"
        speedBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
        if humanoid then humanoid.WalkSpeed = 50 end
    else
        speedBtn.Text = "  Speedhack (50): OFF"
        speedBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        if humanoid then humanoid.WalkSpeed = 16 end
    end
end)

-- 5. Jumphack
jumpBtn.MouseButton1Click:Connect(function()
    states.Jump = not states.Jump
    if states.Jump then
        jumpBtn.Text = "  Jumphack (100): ON"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 40)
        if humanoid then 
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 100 
        end
    else
        jumpBtn.Text = "  Jumphack (100): OFF"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        if humanoid then 
            humanoid.UseJumpPower = true
            humanoid.JumpPower = 50 
        end
    end
end)

-- Window Controls Logic
-- Close (X)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Minimize (-)
local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    contentContainer.Visible = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 320, 0, 35)
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = UDim2.new(0, 320, 0, 300)
        minimizeBtn.Text = "-"
    end
end)

-- Fullscreen / Expand ([])
local isExpanded = false
local normalSize = UDim2.new(0, 320, 0, 300)
local normalPos = UDim2.new(0.5, -160, 0.5, -150)

expandBtn.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    if isExpanded then
        normalSize = mainFrame.Size
        normalPos = mainFrame.Position
        mainFrame.Size = UDim2.new(0, 500, 0, 450)
        expandBtn.Text = "❐"
    else
        mainFrame.Size = normalSize
        mainFrame.Position = normalPos
        expandBtn.Text = "[]"
    end
end)

-- Toggle Menu Visibility with Dot Button (.)
local menuVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    mainFrame.Visible = menuVisible
end)

-- Update character reference on respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    humanoid = newChar:WaitForChild("Humanoid")
    
    -- Reapply active features if needed
    if states.Speed and humanoid then humanoid.WalkSpeed = 50 end
    if states.Jump and humanoid then 
        humanoid.UseJumpPower = true
        humanoid.JumpPower = 100 
    end
end)
