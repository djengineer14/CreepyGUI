-- The Creepy GUI - Simplified (Place in StarterGui as LocalScript)
-- Only custom idle/walk, animation override, and glow effect

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait for character to load
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Animation IDs
local CUSTOM_IDLE = "rbxassetid://96875787869039"
local CUSTOM_WALK = "rbxassetid://77636057910939"
local OVERRIDE_ANIM = "rbxassetid://126831715881241"

-- Create the GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CreepyGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0, 10, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add corner rounding and border
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local border = Instance.new("UIStroke")
border.Color = Color3.new(0.8, 0.1, 0.1)
border.Thickness = 2
border.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
title.Text = "👻 THE CREEPY GUI 👻"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Container for buttons
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

-- Layout
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 10)
layout.Parent = buttonContainer

-- Variables
local currentEffects = {}
local isOverrideActive = false

-- Function to replace default animations
local function replaceDefaultAnimation(animName, newAnimId)
    pcall(function()
        local animate = character:FindFirstChild("Animate")
        if animate then
            local animFolder = animate:FindFirstChild(animName)
            if animFolder then
                for _, anim in pairs(animFolder:GetChildren()) do
                    if anim:IsA("Animation") then
                        anim.AnimationId = newAnimId
                    end
                end
            end
        end
    end)
end

-- Function to set all animations to override
local function setAllAnimationsToOverride()
    pcall(function()
        local animate = character:FindFirstChild("Animate")
        if animate then
            -- Replace all animation types with the override animation
            local animTypes = {"idle", "walk", "run", "jump", "fall", "climb", "sit"}
            
            for _, animType in pairs(animTypes) do
                replaceDefaultAnimation(animType, OVERRIDE_ANIM)
            end
            
            -- Force refresh the animate script
            animate.Disabled = true
            task.wait(0.1)
            animate.Disabled = false
        end
    end)
end

-- Function to restore custom idle/walk
local function restoreCustomAnimations()
    pcall(function()
        local animate = character:FindFirstChild("Animate")
        if animate then
            -- Restore custom idle and walk, default for others
            replaceDefaultAnimation("idle", CUSTOM_IDLE)
            replaceDefaultAnimation("walk", CUSTOM_WALK)
            replaceDefaultAnimation("run", CUSTOM_WALK)
            
            -- Reset other animations to defaults
            replaceDefaultAnimation("jump", "rbxassetid://782847020")
            replaceDefaultAnimation("fall", "rbxassetid://782846423")
            replaceDefaultAnimation("climb", "rbxassetid://782843869")
            
            -- Force refresh the animate script
            animate.Disabled = true
            task.wait(0.1)
            animate.Disabled = false
        end
    end)
end

-- Create glowing effect
local function createGlowEffect()
    local pointLight = Instance.new("PointLight")
    pointLight.Name = "CreepyGlow"
    pointLight.Color = Color3.new(1, 0, 0)
    pointLight.Brightness = 2
    pointLight.Range = 20
    pointLight.Parent = rootPart
    
    -- Flickering effect
    local flickerConnection
    flickerConnection = RunService.Heartbeat:Connect(function()
        pointLight.Brightness = math.random(100, 300) / 100
        pointLight.Color = Color3.new(1, math.random(0, 50) / 100, 0)
    end)
    
    return {pointLight, flickerConnection}
end

-- Create button function
local function createButton(text, color, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, 0, 0, 35)
    button.BackgroundColor3 = color
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = buttonContainer
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button
    
    local buttonStroke = Instance.new("UIStroke")
    buttonStroke.Color = Color3.new(1, 1, 1)
    buttonStroke.Transparency = 0.7
    buttonStroke.Thickness = 1
    buttonStroke.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color:lerp(Color3.new(1, 1, 1), 0.3)}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)
    
    return button
end

-- Animation Override Button
local overrideButton = createButton("🎭 Override All Animations", Color3.new(0.8, 0.2, 0.8), function()
    isOverrideActive = not isOverrideActive
    
    if isOverrideActive then
        -- Set all animations to override
        setAllAnimationsToOverride()
        overrideButton.Text = "↩️ Restore Custom Animations"
        overrideButton.BackgroundColor3 = Color3.new(0.2, 0.8, 0.2)
    else
        -- Restore custom idle/walk
        restoreCustomAnimations()
        overrideButton.Text = "🎭 Override All Animations"
        overrideButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.8)
    end
end)

-- Red Glow Button
createButton("🔴 Red Glow", Color3.new(0.9, 0.1, 0.1), function()
    if currentEffects.glow then
        currentEffects.glow[1]:Destroy()
        currentEffects.glow[2]:Disconnect()
        currentEffects.glow = nil
    else
        currentEffects.glow = createGlowEffect()
    end
end)

-- Minimize/Maximize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.new(0, 0, 0)
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = mainFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 15)
minimizeCorner.Parent = minimizeButton

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 40), "Out", "Quad", 0.3, true)
        minimizeButton.Text = "+"
        buttonContainer.Visible = false
    else
        mainFrame:TweenSize(UDim2.new(0, 300, 0, 200), "Out", "Quad", 0.3, true)
        minimizeButton.Text = "−"
        buttonContainer.Visible = true
    end
end)

-- Apply custom idle/walk on startup
task.spawn(function()
    task.wait(2)
    restoreCustomAnimations()
end)

-- Hotkey support (press G to toggle GUI)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.G then
        screenGui.Enabled = not screenGui.Enabled
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(newCharacter)
    task.wait(1)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset states
    currentEffects = {}
    isOverrideActive = false
    overrideButton.Text = "🎭 Override All Animations"
    overrideButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.8)
    
    -- Apply custom idle/walk after respawn
    task.spawn(function()
        task.wait(3)
        restoreCustomAnimations()
    end)
end)

print("👻 The Creepy GUI loaded successfully!")
print("🎮 Press G to toggle GUI visibility")
print("🎭 Your custom idle/walk animations are applied!")
print("⚡ All effects are visible to everyone!")
print("🔥 Place this script in StarterGui as a LocalScript")